//
//  RepositoryImportView.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/5/19.
//

import SwiftUI

struct RepositoryImportView: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Text("Hello, World!")
        
        Button("取消") {
            appState.isRepositoryImportPresented = false
        }
    }
}

struct RepositoryImportView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryImportView().frame(width: 500, height: 500, alignment: .center)
    }
}
