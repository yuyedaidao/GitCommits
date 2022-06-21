//
//  DBManager.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/5/24.
//
//
//  DBManager.swift
//  YQDB
//
//  Created by 王叶庆 on 2021/2/26.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import GRDB
import Logging
import YQLogger

var _log = Logger(label: "YQDB")
var log = YQLogger(_log)

public class DBManager {
    public static let shared = DBManager()
    private var _db: DatabaseQueue!
    public class var db: DatabaseQueue {
        return Self.shared.db
    }

    public var db: DatabaseQueue {
        get {
            assert(_db != nil, "请先调用prepare初始化数据库")
            return _db
        }
        set {
            _db = newValue
        }
    }

    private init() {}
    public func prepare(name: String? = nil) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        var config = Configuration()
        config.label = "GitCommitDB"
        #if DEBUG
            config.prepareDatabase { db in
                db.trace()
            }
        #endif
        do {
            let path = try dbPath(with: name ?? "database.sql")
            log.debug("db path: \(path)")
            let dbQueue = try DatabaseQueue(
                path: path,
                configuration: config
            )
            _db = dbQueue
        } catch {
            log.error(error)
            fatalError("数据库初始化失败")
        }
    }

    func dbPath(with name: String) throws -> String {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("没有文档路径")
        }
        let path = url.path + "/db"
        if !FileManager.default.fileExists(atPath: path) {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path + "/\(name)"
    }
}
