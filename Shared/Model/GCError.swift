//
//  GCError.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/6/20.
//

import Foundation
struct GCError: Error {
    let message: String?
    init(_ message: String? = nil) {
        self.message = message
    }
}

extension GCError: LocalizedError {
    var errorDescription: String? {
        return message ?? "未知错误"
    }
}
