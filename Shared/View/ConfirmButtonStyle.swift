//
//  ConfirmButtonStyle.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/5/20.
//

import SwiftUI

struct ConfirmButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(4)
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
