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
    case text(String?)
    case blob(Data?)
    case integer(Int?)
    case double(Double?)
    
    var rawValue: String {
        return switch self {
        case .text: "TEXT"
        case .blob: "BLOB"
        case .integer: "INTEGER"
        case .double: "DOUBLE"
        }
    }
    
    init(typeString: String, value: Any? = nil) {
        switch typeString {
        case "BLOB":
            self = .blob((value as? Data) ?? Data())
        case "INTEGER":
            self = .integer((value as? Int) ?? 0)
        case "DOUBLE":
            self = .double((value as? Double) ?? 0)
        default:
            self = .text((value as? String) ?? "")
        }
    }
    
    func withValue(_ value: Any?) -> Self {
        switch self {
        case .blob:
            return .blob((value as? Data))
        case .integer:
            if let value = value as? NSNumber {
                return .integer(Int(truncating: value))
            } else {
                return .integer(nil)
            }
        case .double:
            if let value = value as? NSNumber {
                return .double(Double(truncating: value))
            } else {
                return .double(nil)
            }
        default:
            if let value {
                return .text(String(describing: value))
            } else {
                return .text(nil)
            }
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
    private let connectionQueue = DispatchQueue(label: "thread-safe-connection", attributes: .concurrent)
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
        connectionQueue.sync(flags: .barrier) {
            guard let path = fullDestPath?.path else {
                SundeedLogger.error("DB path missing")
                return nil
            }
            
            var connection: OpaquePointer?
            let flags = write ? (SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX): (SQLITE_OPEN_READONLY | SQLITE_OPEN_FULLMUTEX)
            let rc = sqlite3_open_v2(path, &connection, flags, nil)
            if rc != SQLITE_OK {
                if let connection, let cmsg = sqlite3_errmsg(connection) {
                    SundeedLogger.debug(String(cString: cmsg))
                } else {
                    SundeedLogger.debug("sqlite3_open_v2 returned \(rc)")
                }
                if connection != nil {
                    sqlite3_close_v2(connection)
                }
                return nil
            }
            
            let timeout: Int32 = 500
            if sqlite3_busy_timeout(connection, timeout) != SQLITE_OK {
                if let cmsg = sqlite3_errmsg(connection) {
                    SundeedLogger.debug("Failed set busy_timeout: \(String(cString: cmsg))")
                }
            }
            
            return connection
        }
    }
    
    func closeConnection(_ connection: OpaquePointer?) {
        connectionQueue.sync(flags: .barrier) {
            guard let db = connection else { return }
            
            while let stmt = sqlite3_next_stmt(db, nil) {
                sqlite3_finalize(stmt)
            }
            
#if SQLITE_ENABLE_COLUMN_METADATA
            let rc = sqlite3_close_v2(db)
#else
            let rc = sqlite3_close(db)
#endif
            
            if rc != SQLITE_OK && rc != SQLITE_DONE {
                if let cmsg = sqlite3_errmsg(db) {
                    SundeedLogger.debug("sqlite3_close returned \(rc): \(String(cString: cmsg))")
                } else {
                    SundeedLogger.debug("sqlite3_close returned \(rc)")
                }
            }
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
                            if let value {
                                sqlite3_bind_text(statement, Int32(index+1),
                                                  value, -1, self.SQLITE_TRANSIENT)
                            } else {
                                sqlite3_bind_null(statement, Int32(index+1))
                            }
                        case .integer(let value):
                            if let value {
                                sqlite3_bind_int(statement, Int32(index+1), Int32(value))
                            } else {
                                sqlite3_bind_null(statement, Int32(index+1))
                            }
                        case .double(let value):
                            if let value {
                                sqlite3_bind_double(statement, Int32(index+1), value)
                            } else {
                                sqlite3_bind_null(statement, Int32(index+1))
                            }
                        case .blob(let data):
                            if let data {
                                sqlite3_bind_blob(statement, Int32(index+1),
                                                  NSData(data: data).bytes, Int32(NSData(data: data).length), self.SQLITE_TRANSIENT)
                            } else {
                                sqlite3_bind_null(statement, Int32(index+1))
                            }
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
        guard let conn = connection(write: true) else {
            SundeedLogger.debug("Could not open DB to set PRAGMA")
            return
        }

        var errmsg: UnsafeMutablePointer<Int8>?
        let sql = "PRAGMA journal_mode = WAL;"
        if sqlite3_exec(conn, sql, nil, nil, &errmsg) != SQLITE_OK {
            if let e = errmsg {
                SundeedLogger.debug("PRAGMA error: \(String(cString: e))")
                sqlite3_free(errmsg)
            } else if let cmsg = sqlite3_errmsg(conn) {
                SundeedLogger.debug("PRAGMA failed: \(String(cString: cmsg))")
            }
        } else {
            SundeedLogger.debug("WAL mode set")
        }
        closeConnection(conn)
    }
}
