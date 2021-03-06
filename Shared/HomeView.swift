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
        .navigationTitle("我的Git提交记录")
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
                        }
                    }
                } header: {
                    Text("仓库").contextMenu {
                        Button {
                            appState.isRepositoryImportPresented = true
                        } label: {
                            Text("新建仓库")
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
        HStack(alignment: .center, spacing: 10) {
            MenuItem(title: repository.name)
            Image("\(repository.type.rawValue)_icon")
                .resizable()
                .frame(width: 10, height: 10)
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
