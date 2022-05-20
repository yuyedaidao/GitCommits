//
//  Repository.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/5/18.
//

import Foundation

struct Repository {
    let type: RepositoryType = .gitlab
    let address: String
    let name: String
    let fullName: String
    let owner: String?
    let avatar: String?
    let token: String
    let id: uint64
    let isPrivate: Bool = false
    
}

extension Repository: Identifiable {}
