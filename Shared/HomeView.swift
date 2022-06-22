//
//  HomeView.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/5/17.
//

import SwiftUI
import Combine

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        NavigationView {
            MenuView()
                .frame(minWidth: 80, maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding()
            IntroductionView()
                .frame(minWidth: 100, maxWidth: .infinity, alignment: .center)
        }
        .navigationTitle("Git提交记录")
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar, label: {
                    Image(systemName: "sidebar.left")
                })
            }
        }.sheet(isPresented: $appState.isRepositoryImportPresented) {
            RepositoryImportView()
                .frame(minWidth: 400, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity, alignment: .center)
        }
    }
    
    private func toggleSidebar() {
        #if os(iOS)
        #else
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        #endif
    }
}

struct MenuView: View {
    
    @EnvironmentObject var appState: AppState
    @State var isLoading = false
    
    var body: some View {
        List {
            if appState.repositories.isEmpty {
                NavigationLink {
                    EmptyRepositoryView()
                } label: {
                    MenuItem(title: "导入仓库")
                }
            } else {
                Section {
                    ForEach(appState.repositories) { repository in
                        NavigationLink {
                            RepositoryView(repository: repository)
                        } label: {
                            RepositoryMenuItem(repository: repository)
                        }.contextMenu {
                            Button {
                                updateRepository(repository)
                            } label: {
                                Text("更新信息")
                            }
                            
                            Button {
                                deleteRepository(repository)
                            } label: {
                                Text("删除仓库")
                            }
                        }
                    }
                } header: {
                    if isLoading {
//                        ProgressView().progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text("仓库")
                        .contextMenu {
                            Button {
                                appState.isRepositoryImportPresented = true
                            } label: {
                                Text("新建仓库")
                            }
                        }
                    }
                }
            }
            // 记录
            Section {
                NavigationLink(destination: CommitsView(range: .week)) {
                    MenuItem(title: "本周")
                }
                NavigationLink(destination: CommitsView(range: .today)) {
                    MenuItem(title: "今天")
                }
                NavigationLink(destination: CommitsView(range: .month)) {
                    MenuItem(title: "本月")
                }
                NavigationLink(destination: CommitsView(range: .custom)) {
                    MenuItem(title: "自选")
                }
            } header: {
                Text("记录")
            }

            // 设置
            Spacer()
            NavigationLink(destination: SettingsView()) {
                Text("设置").fontWeight(.medium)
            }

        }
        .listStyle(SidebarListStyle())
    }
    
    func updateRepository(_ repository: Repository) {
        isLoading = true
        
        Task {[self] in
            let type = repository.type
            let token = repository.token
            let branches = repository.branches.components(separatedBy: ",")
            let components = try repository.address.repositoryComponents()
            var url = URL.repositoryRepoApi(with: components, type: type)
            if type == .gitee {
                url += "?access_token=\(token)"
            }
            let oldRpo = repository
            do {
                let repository = try await Network.fetchRepository(with: url, type: type, token: token, branches: branches)
                DispatchQueue.main.async {
                    isLoading = false
                }
                guard repository != oldRpo else {
                    return
                }
                try await DBManager.db.write({ db in
                    try oldRpo.delete(db)
                    try repository.save(db)
                })
                appState.reloadRepositories()

            } catch let error {
                log.error(error)
                DispatchQueue.main.async {
                    isLoading = false
                }
            }
        }
    }
    
    func deleteRepository(_ repository: Repository) {
        do {
            let _ = try DBManager.db.write { db in
                try repository.delete(db)
            }
//            appState.reloadRepositories()
        } catch let error {
            log.error(error)
        }
    }
}


struct MenuItem: View {
    var title: String
    
    var body: some View {
        Text(title)
    }
}

struct RepositoryMenuItem: View {
    let repository: Repository
    
    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            Image("\(repository.type.rawValue)_icon")
                .resizable()
                .frame(width: 12, height: 12)
            MenuItem(title: repository.name)
        }
    }
}

struct IntroductionView: View {
    var body: some View {
        Text("我是个介绍页").frame(alignment: .center)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
