//
//  HomeView.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/5/17.
//

import SwiftUI

struct HomeView: View {
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
                Section("仓库") {
                    ForEach(appState.repositories) { repository in
                        NavigationLink {
                            RepositoryView(repository: repository)
                        } label: {
                            MenuItem(title: "仓库")
                        }
                    }
                }
            }
            // 记录
            Section("记录") {
                NavigationLink(destination: CommitsView()) {
                    MenuItem(title: "本周")
                }
                NavigationLink(destination: CommitsView()) {
                    MenuItem(title: "今天")
                }
                NavigationLink(destination: CommitsView()) {
                    MenuItem(title: "本月")
                }
                NavigationLink(destination: CommitsView()) {
                    MenuItem(title: "自选")
                }
            }
            // 设置
            Spacer()

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
