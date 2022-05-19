//
//  AppState.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/5/18.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var repositories: [Repository] = []
    @Published var isRepositoryImportPresented: Bool = true
}
