//
//  SundeedQLiteConnection.swift
//  SQLiteLibrary
//
//  Created by Nour Sandid on 12/9/18.
//  Copyright © 2018 LUMBERCODE. All rights reserved.
//

import Foundation
import SQLite3

enum ParameterType {
    case text(String)
    case blob(Data)
    
    init(typeString: String) {
        switch typeString {
        case "BLOB":
            self = .blob(Data())
        default:
            self = .text("")
        }
    }
}
class SundeedQLiteConnection {
    static var pool: SundeedQLiteConnection = SundeedQLiteConnection()
    var sqlStatements: [(query: String, parameters: [ParameterType]?)] = []
    var canExecute: Bool = true
    let fileManager = FileManager.default
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    private let queue = DispatchQueue(label: "thread-safe-statements", attributes: .concurrent)
    private let backgroundQueue = DispatchQueue(label: "thread-safe-background-statements", attributes: .concurrent)
    private var connections: [OpaquePointer] = []
    
    lazy var fullDestPath: URL? = {
        do {
            return try FileManager
                .default.url(for: .documentDirectory,
                             in: .userDomainMask,
                             appropriateFor: nil,
                             create: true)
                .appendingPathComponent(Sundeed.shared.databaseFileName)
        } catch {
            SundeedLogger.error(error)
            return nil
        }
    }()
    
    func connection(write: Bool = false) -> OpaquePointer? {
        do {
            var database: OpaquePointer?
            try self.createDatabaseIfNeeded()
            let response = sqlite3_open_v2(fullDestPath?.path,
                                           &database,
                                           write ? SQLITE_OPEN_READWRITE|SQLITE_OPEN_FULLMUTEX : SQLITE_OPEN_READONLY,
                                           nil)
            if response != SQLITE_OK {
                let error = String(cString: sqlite3_errmsg(database))
                SundeedLogger.debug(error)
                return self.connection(write: write)
            }
            return database
        } catch {
            SundeedLogger.debug(error)
            return self.connection(write: write)
        }
    }
    
    func closeConnection(_ connection: OpaquePointer?) {
        while let stmt = sqlite3_next_stmt(connection, nil) {
            sqlite3_finalize(stmt)
        }
        let rc2 = sqlite3_close(connection)
        if rc2 == SQLITE_BUSY {
            self.closeConnection(connection)
        }
    }
    func execute(query: String?, parameters: [ParameterType]? = nil, force: Bool = false) {
        queue.sync(flags: .barrier) {
            SundeedLogger.debug("Number of queries in queue: \(self.sqlStatements.count)")
            guard let query = query else {
                return
            }
            if self.canExecute || force {
                var writeConnection = self.connection(write: true)
                self.canExecute = false
                var statement: OpaquePointer?
                let prepare = sqlite3_prepare_v2(writeConnection, query, -1, &statement, nil)
                if  prepare == SQLITE_OK {
                    parameters?.enumerated().forEach({ (index, value) in
                        switch value {
                        case .text(let value):
                            sqlite3_bind_text(statement, Int32(index+1),
                                              value, -1, self.SQLITE_TRANSIENT)
                        case .blob(let data):
                            sqlite3_bind_blob(statement, Int32(index+1),
                                              NSData(data: data).bytes, Int32(NSData(data: data).length), self.SQLITE_TRANSIENT)
                        }
                    })
                    if sqlite3_step(statement) == SQLITE_DONE {
                        sqlite3_finalize(statement)
                    } else {
                        let error = String(cString: sqlite3_errmsg(writeConnection))
                        SundeedLogger.debug(error)
                        sqlite3_finalize(statement)
                        self.insertStatement(query, parameters)
                    }
                } else {
                    if prepare != SQLITE_ERROR {
                        sqlite3_finalize(statement)
                        self.insertStatement(query, parameters)
                    }
                }
                let combination = self.popStatement()
                self.closeConnection(writeConnection)
                writeConnection = nil
                statement = nil
                if let oldQuery = combination?.query {
                    backgroundQueue.async(flags: .barrier) {
                        self.execute(query: oldQuery, parameters: combination?.parameters,
                                     force: true)
                    }
                } else {
                    self.canExecute = true
                }
            } else {
                self.insertStatement(query, parameters)
            }
        }
    }
    private func insertStatement(_ query: String, _ parameters: [ParameterType]?) {
        self.sqlStatements.insert((query, parameters), at: 0)
    }
    private func popStatement() -> (query: String, parameters: [ParameterType]?)? {
        return self.sqlStatements.popLast()
    }
    private func removeAllStatements() {
        self.sqlStatements.removeAll()
    }
    func deleteDatabase() {
        queue.sync(flags: .barrier) {
            guard let fullDestinationPath = fullDestPath else { return }
            removeAllStatements()
            do {
                try fileManager.removeItem(at: fullDestinationPath)
                try deleteImagesDirectory()
            } catch {
                SundeedLogger.error(error)
            }
        }
    }
    private func deleteImagesDirectory() throws {
        guard let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            .first else {
            throw SundeedQLiteError.cannotAccessDocumentDirectory
        }
        
        let directoryURL = documentsDirectoryURL.appendingPathComponent("SundeedQLite/Image", isDirectory: true)
        if fileManager.fileExists(atPath: directoryURL.path) {
            try fileManager.removeItem(at: directoryURL)
        }
    }
    private func createDatabaseIfNeeded() throws {
        guard let fullDestinationPath = fullDestPath else { return }
        let fullDestPathString = fullDestPath!.path
        if !fileManager.fileExists(atPath: fullDestPathString) {
            try "".write(to: fullDestinationPath, atomically: false, encoding: .utf8)
            setPragma()
        }
    }
    private func setPragma() {
        let connection = connection()
        var statement: OpaquePointer?
        sqlite3_prepare_v2(connection,
                           "PRAGMA journal_mode = WAL;",-1,
                           &statement, nil)
        if sqlite3_step(statement) == SQLITE_DONE {
            sqlite3_finalize(statement)
        } else {
            let error = String(cString: sqlite3_errmsg(connection))
            SundeedLogger.debug(error)
            sqlite3_finalize(statement)
        }
        SundeedQLiteConnection.pool.closeConnection(connection)
    }
}
