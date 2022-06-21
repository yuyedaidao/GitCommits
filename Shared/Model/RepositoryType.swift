//
//  RepositoryType.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/5/18.
//

import Foundation

enum RepositoryType: String, Codable {
    case github // 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
    case gitlab // uPe4UBzF_s532mmhHeNV
    case gitee // 95b8adf66012a25d102ec8adb4e1573d
}

extension RepositoryType: CaseIterable {}
extension RepositoryType: Identifiable {
    var id: String {
        return rawValue
    }
}
