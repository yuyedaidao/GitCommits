//
//  Repository.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/5/18.
//

import Foundation
import GRDB

struct Repository {
    let id: uint64
    let type: RepositoryType
    var address: String
    var name: String
    var fullName: String
    var owner: String?
    var avatar: String?
    var token: String
    var branches: String
    var defaultBranch: String
    var createdDate: Date
}

extension Repository: Identifiable {}
extension Repository: Codable {}
extension Repository: FetchableRecord, PersistableRecord {
    enum Columns: String, CodingKey, ColumnExpression {
        case id
        case type
        case address
        case name
        case fullName
        case owner
        case avatar
        case token
        case branches
        case defaultBranch
        case createdDate
    }
}

extension Repository: Equatable {}
