//
//  RepositoryType.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/5/18.
//

import Foundation

enum RepositoryType: String, Codable {
    case github
    case gitlab
}

extension RepositoryType: CaseIterable {}
extension RepositoryType: Identifiable {
    var id: String {
        return rawValue
    }
}
