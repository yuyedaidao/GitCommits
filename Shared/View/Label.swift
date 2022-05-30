//
//  Label.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/5/30.
//

import SwiftUI

struct Label: View {
    let text: String
    init(_ text: String) {
        self.text = text
    }
    var body: some View {
        Text(text)
            .font(.headline)
            .frame(width: 70, alignment: .leading)
    }
}

struct Label_Previews: PreviewProvider {
    static var previews: some View {
        Label("hello")
    }
}
