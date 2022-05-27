//
//  SimpleAlert.swift
//  GitCommits (macOS)
//
//  Created by 王叶庆 on 2022/5/23.
//

import Foundation
import SwiftUI

//struct SimpleAlert: ViewModifier {
//    @Binding var message: String?
//    @State var isPresented: Bool
//    
//    init(message: Binding<String?>) {
//        _isPresented = State(wrappedValue: message.wrappedValue != nil)
//        _message = message
//    }
//    
//    func body(content: Content) -> some View {
//        return content.alert(message ?? "", isPresented: $isPresented) {
//            
//        }
//    }
//}
//
//extension View {
//    func simpleAlert(_ message: Binding<String?>) -> some View {
//        modifier(SimpleAlert(message: message))
//    }
//}
