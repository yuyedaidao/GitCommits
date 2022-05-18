//
//  GitCommitsApp.swift
//  Shared
//
//  Created by 王叶庆 on 2022/5/16.
//

import SwiftUI

@main
struct GitCommitsApp: App {
    let appState = AppState()
    var body: some Scene {
        WindowGroup {
            HomeView()
            .frame(minWidth: 600,  maxWidth: CGFloat.infinity, minHeight: 400, maxHeight: CGFloat.infinity, alignment: .center)
            .environmentObject(appState)
        }
    }
    
}
