//
//  Network.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/6/20.
//

import Foundation
import Alamofire

class Network {
    class func fetchRepository(with url: String, type: RepositoryType, token: String, branches: [String] = []) async throws -> Repository {
        switch type {
        case .github:
            let data = try await AF.request(url, method: .get, headers: ["Accept": "application/json", "Authorization" : "token \(token)"]).cURLDescription { description in
                print(description)
            }.validate().serializingData().value
            guard let object = try JSONSerialization.jsonObject(with: data) as? Map else {
                throw GCError("返回数据结构不正确")
            }
            guard let address = object["html_url"] as? String, let name = object["name"] as? String, let fullName = object["full_name"] as? String, let id = object["id"] as? uint64 else {
                throw GCError("返回的数据不完整")
            }
            let repository = Repository(id: id, type: type, address: address, name: name, fullName: fullName, owner: object.value(for: "owner.login") as? String, avatar: object.value(for: "owner.avatar_url") as? String, token: token, branches: branches.joined(separator: ","), defaultBranch: object["default_branch"] as? String ?? "main")
            return repository
        case .gitlab:
            let data = try await AF.request(url, method: .get, headers: ["PRIVATE-TOKEN" : token, "Accept": "application/json"]).cURLDescription { description in
                print(description)
            }.validate().serializingData().value
            guard let object = try JSONSerialization.jsonObject(with: data) as? Map else {
                throw GCError("返回数据结构不正确")
            }
            guard let address = object["web_url"] as? String, let name = object["name"] as? String, let fullName = object["path_with_namespace"] as? String, let id = object["id"] as? uint64 else {
                throw GCError("返回的数据不完整")
            }
            let repository = Repository(id: id, type: type, address: address, name: name, fullName: fullName, owner: object.value(for: "owner.name") as? String, avatar: object.value(for: "owner.avatar") as? String, token: token, branches: branches.joined(separator: ","), defaultBranch: object["default_branch"] as? String ?? "master")
            return repository
        case .gitee:
            let data = try await AF.request(url, method: .get, headers: ["Accept": "application/json"]).cURLDescription { description in
                print(description)
            }.validate().serializingData().value
            guard let object = try JSONSerialization.jsonObject(with: data) as? Map else {
                throw GCError("返回数据结构不正确")
            }
            guard let address = object["html_url"] as? String, let name = object["name"] as? String, let fullName = object["full_name"] as? String, let id = object["id"] as? uint64 else {
                throw GCError("返回的数据不完整")
            }
            let repository = Repository(id: id, type: type, address: address, name: name, fullName: fullName, owner: object.value(for: "owner.name") as? String, avatar: object.value(for: "owner.avatar_url") as? String, token: token, branches: branches.joined(separator: ","), defaultBranch: object["default_branch"] as? String ?? "master")
            return repository
        }
    }
}
