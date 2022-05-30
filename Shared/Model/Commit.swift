//
//  Commit.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/5/26.
//

import Foundation

struct Commit {
    let cid: String
    let date: Date
    let message: String
    let author: String
    let email: String
    let url: String
}

extension Commit: Codable, Hashable, Identifiable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(cid)
        hasher.combine(date)
        hasher.combine(message)
        hasher.combine(author)
        hasher.combine(email)
        hasher.combine(url)
    }
    
    var id: Int {
        hashValue
    }
}

extension Commit {
    static func from(_ object: Map, repositoryType: RepositoryType = .gitlab) -> Commit? {
        switch repositoryType {
        case .github:
            let dateFormatter = ISO8601DateFormatter()
            guard let cid = object["sha"] as? String,
                  let _date = object.value(for: "commit.author.date") as? String,
                  let date = dateFormatter.date(from: _date),
                  let message = object.value(for: "commit.message") as? String,
                  let author = object.value(for: "commit.author.name") as? String,
                  let email = object.value(for: "commit.author.email") as? String,
                  let url = object["html_url"] as? String else {
                return nil
            }
            return Commit(cid: cid, date: date, message: message, author: author, email: email, url: url)
        case .gitlab:
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = [.withTimeZone, .withInternetDateTime, .withFractionalSeconds]
            guard let cid = object["id"] as? String,
                  let _date = object["created_at"] as? String,
                  let date = dateFormatter.date(from: _date),
                  let message = object["message"] as? String,
                  let author = object["author_name"] as? String,
                  let email = object["author_email"] as? String,
                  let url = object["web_url"] as? String else {
                return nil
            }
            return Commit(cid: cid, date: date, message: message, author: author, email: email, url: url)
        }
    }
}
