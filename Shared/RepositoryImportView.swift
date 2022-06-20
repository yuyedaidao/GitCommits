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
                        } else if address.contains("gitee.com") {
                            type = RepositoryType.gitee.rawValue
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
                                    guard let index = branches.firstIndex(of: name) else {return}
                                    branches.remove(at: index)
                                } label: {
                                    Image(systemName: "xmark.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 12, height: 12)
                                        .foregroundColor(.secondary)
                                }.buttonStyle(.borderless)
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
            .animation(Animation.default, value: branches)
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
    
    
    func importRepository() {
        isLoading = true
        
        Task {[self] in
            let type = RepositoryType(rawValue: type)!
            let components = try address.repositoryComponents()
            var url = URL.repositoryRepoApi(with: components, type: type)
            if type == .gitee {
                url += "?access_token=\(token)"
            }
            do {
                let repository = try await Network.fetchRepository(with: url, type: type, token: token, branches: branches)
                let exists = try await DBManager.db.read { db -> Bool in
                    try repository.exists(db)
                }
                isLoading = false
                if exists {
                    throw GCError("已存在此地址的仓库")
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
