//
//  GitCommitsApp.swift
//  Shared
//
//  Created by 王叶庆 on 2022/5/16.
//

import SwiftUI

@main
struct GitCommitsApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                List {
                    NavigationLink("Purple", destination: ColorDetail(color: .purple))
                    NavigationLink("Pink", destination: ColorDetail(color: .pink))
                    NavigationLink("Orange", destination: ColorDetail(color: .orange))
                }
                ContentView()
                    .frame(minWidth: 600,  maxWidth: CGFloat.infinity, minHeight: 400, maxHeight: CGFloat.infinity, alignment: .center)
                    .navigationTitle("我的Git提交记录")
            }
        }
    }
    
    struct ColorDetail: View {
        var color: Color

        var body: some View {
            color
             .frame(width: 200, height: 200)
             .navigationTitle(color.description.capitalized)
        }
    }
}
