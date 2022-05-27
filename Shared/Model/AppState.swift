//
//  AppState.swift
//  GitCommits
//
//  Created by 王叶庆 on 2022/5/18.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var repositories: [Repository] = []
    @Published var isRepositoryImportPresented: Bool = false
    
    init() {
        prepareDB()
        reloadRepositories()
    }
    
    private func prepareDB() {
        DBManager.shared.prepare(name: "git_commits")
        do {
            try DBManager.db.write { db in
                try db.create(table: Repository.databaseTableName, temporary: false, ifNotExists: true) { table in
                    let Columns = Repository.Columns.self
                    table.column(Columns.address.rawValue, .text).primaryKey()
                    table.column(Columns.id.rawValue, .integer)
                    table.column(Columns.type.rawValue, .text)
                    table.column(Columns.avatar.rawValue, .text)
                    table.column(Columns.name.rawValue, .text)
                    table.column(Columns.fullName.rawValue, .text)
                    table.column(Columns.owner.rawValue, .text)
                    table.column(Columns.token.rawValue, .text)
                    table.column(Columns.branches.rawValue, .text)
                }
            }
        } catch let error {
//            log.error(error)
        }
    }
    
    func reloadRepositories() {
        do {
            let repositories = try DBManager.db.read { db in
                try Repository.fetchAll(db)
            }
            self.repositories = repositories
        } catch let error {
//            log.error(error)
        }
    }
}
