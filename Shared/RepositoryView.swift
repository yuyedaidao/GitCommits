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
    let repository: Repository
    var body: some View {
        let request = try! URLRequest(url: repository.address, method: .get)
        return NavigationView {
            WebView(request: request).toolbar {
       
                ToolbarItemGroup(placement: .confirmationAction) {
                    Button(action: {
                        appState.isRepositoryImportPresented = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                    NavigationLink {
                        Text("好的")
                    } label: {
                        Image(systemName: "gear.circle")
                    }
                }
            }
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
