//
//  RepositoriesView.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/5/18.
//

import SwiftUI

struct RepositoryView: View {
    
    let repository: Repository
    
    var body: some View {
        Text("Hello, Repositories!")
    }
}

struct RepositoriesView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryView(repository: Repository(type: .github, address: "", name: "appicon", owner: "padding"))
    }
}


struct EmptyRepositoryView: View {
    var body: some View {
        Button {
            
        } label: {
            VStack(spacing: 6) {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                Text("导入一个仓库")
            }
        }.buttonStyle(PlainButtonStyle())
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {

                    }, label: {
                        Image(systemName: "plus").imageScale(.large)
                    })
                }
            }
    }
}
