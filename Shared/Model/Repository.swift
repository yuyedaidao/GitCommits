//
//  Repository.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/5/18.
//

import Foundation

struct Repository {
    let type: RepositoryType
    let address: String
    let name: String
    let owner: String
}

extension Repository: Identifiable {
    var id: String {
        return address
    }
}
