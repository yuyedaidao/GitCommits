//
//  GitCommitsApp.swift
//  Shared
//
//  Created by 王叶庆 on 2022/5/16.
//

import SwiftUI

@main
struct GitCommitsApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(AppState())
                .frame(minWidth: 600,  maxWidth: CGFloat.infinity, minHeight: 400, maxHeight: CGFloat.infinity, alignment: .center)
                .onAppear {
                    print("on appear")
                }
        }
        
//        WindowGroup(id: "repository_import") {
//            RepositoryImportView()
//                .frame(minWidth: 400,  maxWidth: CGFloat.infinity, minHeight: 500, maxHeight: CGFloat.infinity, alignment: .center)
//        }
//            .handlesExternalEvents(matching: ["gc_import_repository"])
        
//        Settings {
//            VStack {
//                Text("我是设置 先不实现")
//            }.frame(width: 500, height: 300)
//        }
    }
    
}
