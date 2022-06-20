//
//  URLExtension.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/6/20.
//

import Foundation
typealias RepositoryComponentsTuple = (scheme: String, host: String, port: Int?, path: String)
extension URL {
    func repositoryComponents() throws -> RepositoryComponentsTuple {
        var path = path
        guard !path.isEmpty else {
            throw GCError("请指定正确的仓库地址")
        }
        if path.hasPrefix("/") {
            path = String(path.dropFirst())
        }
        if path.hasSuffix(".git") {
            path = String(path.dropLast(".git".count))
        }
        guard let scheme = self.scheme, let host = self.host else {
            throw GCError("请指定正确的仓库地址")
        }
        return (scheme, host, self.port, path)
    }
    
    static func repositoryRepoApi(with components: RepositoryComponentsTuple, type: RepositoryType) -> String {
        let (scheme, host, port, path) = components
        switch type {
        case .github:
            var request = "\(scheme)://api.\(host)"
            if let port = port {
                request = request + ":\(port)"
            }
            request = request + "/repos/\(path)"
            return request
        case .gitlab:
            var request = "\(scheme)://\(host)"
            if let port = port {
                request = request + ":\(port)"
            }
            request = request + "/api/v4/projects/\(path.replacingOccurrences(of: "/", with: "%2F"))"
            return request
        case .gitee:
            var request = "\(scheme)://\(host)"
            if let port = port {
                request = request + ":\(port)"
            }
            request = request + "/api/v5/repos/\(path)"
            return request
        }
    }
}

extension String {
    func repositoryComponents() throws -> RepositoryComponentsTuple {
        guard let url = URL(string: self) else {
            throw GCError("错误的地址")
        }
        return try url.repositoryComponents()
    }
}
