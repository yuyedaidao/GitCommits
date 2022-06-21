//
//  RepositoriesView.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/5/18.
//

import SwiftUI
import WebKit

struct RepositoryView: View {
    @EnvironmentObject var appState: AppState
    @State var isShowSettingsPlan: Bool = false
    let repository: Repository
    var body: some View {
        let request = try! URLRequest(url: repository.address, method: .get)
        return HStack {
            WebView(request: request).toolbar {
                ToolbarItemGroup(placement: .confirmationAction) {
                    Button(action: {
                        appState.isRepositoryImportPresented = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                    Button {
                        isShowSettingsPlan.toggle()
                    } label: {
                        Image(systemName: "gear.circle")
                    }
                }
            }
            if isShowSettingsPlan {
                RepositorySettingsView(repository: repository)
            }
        }.animation(Animation.default, value: isShowSettingsPlan)
    }
}

struct RepositorySettingsView: View {
    @EnvironmentObject var appState: AppState
    let repository: Repository
    @State var isInputPresented: Bool = false
    @State var branches: [String] = []
    @State var name: String = ""

    init(repository: Repository) {
        self.repository = repository
        if !repository.branches.isEmpty {
            _branches = State(initialValue: repository.branches.components(separatedBy: ","))
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
          
            HStack(alignment: .top, spacing: 0) {
                Label("检索分支")
                VStack(alignment: .leading, spacing: 4) {
                    Button {
                        isInputPresented.toggle()
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
                                var newRep = repository
                                newRep.branches = branches.joined(separator: ",")
                                do {
                                    try DBManager.db.write { db in
                                        try newRep.update(db)
                                    }
                                } catch let error {
                                    log.error(error)
                                }
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
                .sheet(isPresented: $isInputPresented, content: {
                    FloatInputView(placeholder: "输入分支名字", isPresented: $isInputPresented) { name in
                        defer {
                            isInputPresented.toggle()
                        }
                        guard !branches.contains(name) else {
                            return
                        }
                        self.branches = branches + [name]
                        var newRep = repository
                        newRep.branches = self.branches.joined(separator: ",")
                        
                        do {
                            try DBManager.db.write { db in
                                try newRep.update(db)
                            }
                        } catch let error {
                            log.error(error)
                        }
                        
                    }
                })
            }
            
            Spacer()
        }.padding()
            .frame(minWidth: 300, alignment: .topLeading)
            .onDisappear {
                appState.reloadRepositories()
            }
        
    }
    
    
}

struct EmptyRepositoryView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        Button {
            appState.isRepositoryImportPresented = true
        } label: {
            VStack(spacing: 6) {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                Text("导入一个仓库")
            }
        }.buttonStyle(PlainButtonStyle())

    }
}
