//
//  FloatInputView.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/5/27.
//

import SwiftUI

struct FloatInputView: View {
    let placeholder: String
    @Binding var isPresented: Bool
    let submitHandler: (String) -> ()

    @State var input: String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            TextField(placeholder, text: $input)
            
            HStack(alignment: .center, spacing: 20) {
                Button {
                    isPresented = false
                } label: {
                    Text("取消")
                }
                Button {
                    guard !input.isEmpty else {
                        return
                    }
                    submitHandler(input)
                } label: {
                    Text("提交")
                }
            }
        }
        .frame(width: 200)
        .padding(20)
            
    }
}
