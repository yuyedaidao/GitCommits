//
//  CommitsView.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/5/18.
//

import SwiftUI
import Alamofire

enum CommitsRange {
    case today
    case week
    case month
    case custom
}

struct CommitsView: View {
    class CacheKey {
        let value: String
        init(_ value: String) {
            self.value = value
        }
    }
    class CacheValue {
        let value: [Commit]
        init(_ value: [Commit]) {
            self.value = value
        }
    }
    
    let cache = NSCache<CacheKey, CacheValue>()
    let range: CommitsRange
    @EnvironmentObject var appState: AppState
    
    @State var isLoading: Bool = false
    @State var commits: [Commit] = []
    @AppStorage("orderByAsc") var orderByAsc: Bool = true
    @AppStorage("emails") var emails: Set<String> = []
    @AppStorage("filterRegxes") var filterRegxes: Set<String> = []
    
    init(range: CommitsRange) {
        self.range = range
        if let commits = cache.object(forKey: CacheKey("commits_"))?.value, !commits.isEmpty {
            print("cached commits \(commits)")
            self.commits = commits
        }
    }
    
    var body: some View {
        ZStack {
            List(commits) { item in
                Text(item.message)
            }
            if isLoading {
                ZStack {
                    ProgressView()
                }
            }
        }.onAppear {
            loadData()
        }
    }
    
    func loadData(_ force: Bool = false) {
        func load() {
            isLoading = true
            let repositories = appState.repositories
            DispatchQueue.global().async {
                Task {
                    var commits: [Commit] = []
                    for repository in repositories {
                        switch repository.type {
                        case .gitlab:
                            for branch in repository.branches.components(separatedBy: ",") {
                                guard !branch.isEmpty, let url = URL(string: repository.address) else {continue}
                                var request = url.scheme! + "://" + url.host!
                                if let port = url.port {
                                    request += ":\(port)"
                                }
                                request += "/api/v4/projects/\(repository.id)/repository/commits"
                                let data = try await AF.request(request, method: .get, parameters: ["ref_name" : branch], headers: ["PRIVATE-TOKEN" : repository.token, "Accept": "application/json"]).validate().serializingData().value
                                guard let array = try JSONSerialization.jsonObject(with: data) as? [Map] else {
                                    continue
                                }
                                commits.append(contentsOf: array.compactMap({ item in
                                    Commit.from(item)
                                }).filter {
                                    !emails.contains($0.email) && !filterRegxes.regexContains($0.message)
                                })
                                print("branches \(branch)  commits: \(commits)")
                            }
                        case .github:
                            fatalError()
                        }
                    }
                    commits = commits.sorted { a, b in
                        orderByAsc ? a.date < b.date : a.date > b.date
                    }
                    DispatchQueue.main.async {
                        self.commits = commits
                        isLoading = false
                    }
                }
            }
        }
        if force {
            load()
        } else {
            guard commits.isEmpty else {
                return
            }
            load()
        }
        
    }
}
extension Set where Element == String {
    func regexContains(_ string: String) -> Bool {
        for regex in self {
            guard string.range(of: regex, options: .regularExpression) != nil else {
                continue
            }
            return true
        }
        return false
    }
}

struct CommitsView_Previews: PreviewProvider {
    static var previews: some View {
        CommitsView(range: .today)
    }
}
