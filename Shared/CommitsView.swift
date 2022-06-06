//
//  CommitsView.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/5/18.
//

import SwiftUI
import Alamofire
import SwiftDate

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
    @State var startDate: Date
    @State var endDate: Date
    
    @EnvironmentObject var appState: AppState
    @State var isLoading: Bool = false
    @State var commits: [Commit] = []
    @AppStorage("orderByAsc") var orderByAsc: Bool = true
    @AppStorage("emails") var emails: Set<String> = []
    @AppStorage("filterRegxes") var filterRegxes: Set<String> = []
    
    init(range: CommitsRange) {
        self.range = range
        
        switch range {
        case .today:
            _startDate = State(initialValue: Date.now.dateAt(.startOfDay))
            _endDate = State(initialValue: Date.now.dateAt(.endOfDay))
        case .week:
            _startDate = State(initialValue: Date.now.dateAt(.startOfWeek))
            _endDate = State(initialValue: Date.now.dateAt(.endOfWeek))
        case .month:
            _startDate = State(initialValue: Date.now.dateAt(.startOfMonth))
            _endDate = State(initialValue: Date.now.dateAt(.endOfMonth))
        case .custom:
            _startDate = State(initialValue: Date.now.dateAt(.startOfWeek))
            _endDate = State(initialValue: Date.now.dateAt(.endOfWeek))
        }
        if let commits = cache.object(forKey: CacheKey("commits_"))?.value, !commits.isEmpty {
            self.commits = commits
        }
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                if range == .custom {
                    HStack(alignment: .center, spacing: 20) {
                        Image(systemName: "calendar").resizable().frame(width: 20, height: 20).scaledToFit()
                        DatePicker("开始日期", selection: $startDate, displayedComponents: [.date])
                        DatePicker("结束日期", selection: $endDate, displayedComponents: [.date])
                    }.datePickerStyle(.stepperField)
                        .padding()
                }
                List(commits) { item in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.message)
                        HStack {
                            Text(item.author)
                            Spacer()
                            Text(item.date.toISO())
                        }
                    }
                    .padding()
                    .background(Color.gray)
                    .background(in: RoundedRectangle(cornerRadius: 4))
                }
            }
            if isLoading {
                ZStack {
                    ProgressView()
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .confirmationAction) {
                Button(action: {
                    loadData(true)
                }, label: {
                    Image(systemName: "goforward")
                })
            }
        }
        .onAppear {
            loadData()
        }
    }
    
    func loadData(_ force: Bool = false) {
        func load() {
            isLoading = true
            let repositories = appState.repositories
            DispatchQueue.global().async {
                Task {
                    let dateFormatter = ISO8601DateFormatter()
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
                                var parameters: Map =  ["ref_name" : branch]
                                parameters["since"] = dateFormatter.string(from: startDate)
                                parameters["until"] = dateFormatter.string(from: endDate)
                                
#if DEBUG
                                print("parameters : \(parameters) ")
#endif
                                let data = try await AF.request(request, method: .get, parameters: parameters, headers: ["PRIVATE-TOKEN" : repository.token, "Accept": "application/json"]).validate().serializingData().value
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
