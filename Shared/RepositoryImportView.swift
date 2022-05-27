//
//  RepositoryImportView.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/5/19.
//

import SwiftUI
import Combine
import Alamofire
import GRDB

// MARK: sparrow b7AT4i1xf6HUmPJwdRzx
// go-sparrow uPe4UBzF_s532mmhHeNV

struct RepositoryImportView: View {
    
    @EnvironmentObject var appState: AppState
    @State var address: String = ""
    @State var token: String = ""
    @State var type: String = RepositoryType.gitlab.rawValue
    @State var alertMessage: String = ""
    @State var isAlertPresented: Bool = false
    @State var isLoading: Bool = false
    @State var branches: [String] = []
    @State var isInputPresented: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {}
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 15) {
                HStack(alignment: .center, spacing: 0) {
                    Label("仓库地址")
                    TextField("仓库地址", text: $address) { changed in
                    } onCommit: {
                        if address.contains("github.com") {
                            type = RepositoryType.github.rawValue
                        } else {
                            type = RepositoryType.gitlab.rawValue
                        }
                    }
                }
                HStack(alignment: .center, spacing: 0) {
                    Label("仓库类型")
                    Picker(selection: $type) {
                        ForEach(RepositoryType.allCases) { type in
                            Text(type.rawValue)
                        }
                    } label: {
                        EmptyView()
                    }
                }
                HStack(alignment: .center, spacing: 0) {
                    Label("访问令牌")
                    TextField("访问令牌", text: $token)
                }
                
                HStack(alignment: .top, spacing: 0) {
                    Label("检索分支")
                    VStack(alignment: .leading, spacing: 4) {
                        Button {
                            isInputPresented = true
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12, height: 12)
                        }
                        Flow(mode: .scrollable, items: branches, itemSpacing: 8) { name in
                            HStack(alignment: .center, spacing: 4) {
                                Text(name).foregroundColor(.white)
                                Button {
                                    // TODO: 增加确认
                                    
                                    
                                } label: {
                                    Image(systemName: "xmark.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 12, height: 12)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .frame(height: 28, alignment: .center)
                            .padding(.horizontal, 10)
                            .background(Color.blue)
                            .cornerRadius(14)
                        }
                    }
                }
                
                Spacer()
                HStack(alignment: .center, spacing: 10) {
                    Spacer()
                    Button("取消") {
                        appState.isRepositoryImportPresented = false
                    }
                    Spacer()
                    Button("导入") {
                        importRepository()
                    }
                    .buttonStyle(ConfirmButtonStyle())
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                                
            }
            .padding()
            .alert(alertMessage, isPresented: $isAlertPresented) {
                
            }
            .sheet(isPresented: $isInputPresented, content: {
                FloatInputView(placeholder: "输入分支名字", isPresented: $isInputPresented) { name in
                    defer {
                        isInputPresented = false
                    }
                    guard !branches.contains(name) else {
                        return
                    }
                    self.branches = branches + [name]
                }
            })
            .disabled(self.isLoading)
            .blur(radius: self.isLoading ? 2 : 0)
            if isLoading {
                ZStack {
                    ProgressView()
                }
            }
        }
    }
    
    func Label(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .frame(width: 70, alignment: .leading)
    }
    
    func importRepository() {
        guard !address.isEmpty else {
            alert("仓库地址不能为空")
            return
        }
        guard let url = URL(string: address) else {
            alert("请填写正确的仓库地址")
            return
        }
        guard !token.isEmpty else {
            alert("请填写访问令牌")
            return
        }
        var path = url.path
        guard !path.isEmpty else {
            alert("请填写正确的仓库地址")
            return
        }
        if path.hasPrefix("/") {
            path = String(path.dropFirst())
        }
        if path.hasSuffix(".git") {
            path = String(path.dropLast(".git".count))
        }
        guard let scheme = url.scheme, let host = url.host else {
            alert("请填写正确的仓库地址")
            return
        }
        
        var request = "\(scheme)://\(host)"
        if let port = url.port {
            request = request + ":\(port)"
        }
        request = request + "/api/v4/projects/\(path.replacingOccurrences(of: "/", with: "%2F"))"
        isLoading = true
        let type = RepositoryType(rawValue: type)!
        switch type {
        case .gitlab:
            Task {[self] in
                do {
                    let data = try await AF.request(request, method: .get, headers: ["PRIVATE-TOKEN" : token, "Accept": "application/json"]).cURLDescription { description in
                        print(description)
                    }.validate().serializingData().value
                    guard let object = try JSONSerialization.jsonObject(with: data) as? Map else {
                        isLoading = false
                        alert("返回数据结构不正确")
                        return
                    }
                    guard let address = object["web_url"] as? String, let name = object["name"] as? String, let fullName = object["path_with_namespace"] as? String, let id = object["id"] as? uint64 else {
                        alert("返回的数据不完整")
                        return
                    }
                    let repository = Repository(id: id, type: type, address: address, name: name, fullName: fullName, owner: object.value(for: "owner.name") as? String, avatar: object.value(for: "owner.avatar") as? String, token: token, branches: branches.joined(separator: ","))
                    let exists = try await DBManager.db.read { db -> Bool in
                        try repository.exists(db)
                    }
                    isLoading = false
                    if exists {
                        alert("已存在此地址的仓库")
                    } else {
                        try await DBManager.db.write({ db in
                            try repository.save(db)
                        })
                        appState.reloadRepositories()
                        appState.isRepositoryImportPresented = false
                    }
                    
                } catch let error {
                    isLoading = false
                    alert("\(error)")
                }
            }
        case .github:
            fatalError()
        }
    }
    
    
    func fetchProjectInfo() async {
        
    }
    
    func alert(_ message: String) {
        alertMessage = message
        isAlertPresented = true
    }
}

struct RepositoryImportView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryImportView().frame(width: 500, height: 500, alignment: .center)
    }
}
