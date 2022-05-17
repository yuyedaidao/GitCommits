//
//  HomeView.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/5/17.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        HStack(alignment: .top) {
            MenuView()
                .frame(idealWidth: 200, maxWidth: .infinity, alignment: .topLeading)
            DetailView()
                .background(Color.secondary)
        }
    }
}

struct MenuView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 仓库
            MenuItem(title: "仓库")
            // 记录
            MenuItem(title: "记录")
            // 设置
            Spacer()
            MenuItem(title: "设置")
        }
    }
}

struct MenuItem: View {
    var title: String
//    var isSelected: Bool
    
    var body: some View {
        Button(title) {
            
        }
    }
}

struct DetailView: View {
    var body: some View {
        Text("我是个详情页")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
