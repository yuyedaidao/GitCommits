//
//  RepositoryImportView.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/5/19.
//

import SwiftUI
import Combine

struct RepositoryImportView: View {
    
    @EnvironmentObject var appState: AppState
    @State var address: String = ""
    @State var token: String = ""
    @State var type: String = RepositoryType.gitlab.rawValue
    private var cancellables = Set<AnyCancellable>()
    init() {}
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(alignment: .center, spacing: 0) {
                Label("仓库地址")
                TextField("仓库地址", text: $address)
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
            
            Divider()
            
        }.padding()
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
        .padding()
    }
    
    func Label(_ text: String) -> some View {
        Text(text).frame(width: 70, alignment: .leading)
    }
    
    func importRepository() {
        guard !address.isEmpty else {
            print("仓库地址不能为空")
            return
        }
    }
}

struct RepositoryImportView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryImportView().frame(width: 500, height: 500, alignment: .center)
    }
}
