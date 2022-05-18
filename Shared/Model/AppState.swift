//
//  AppState.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/5/18.
//

import Foundation

class AppState: ObservableObject {
    @Published var repositories: [Repository] = []
}
