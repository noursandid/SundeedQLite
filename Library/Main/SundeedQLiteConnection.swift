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
    var sqlStatements: [(String, [ParameterType]?, (()->Void)?)] = []
    var canExecute: Bool = true
    let fileManager = FileManager.default
    let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                       .userDomainMask,
                                                       true).first!
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    lazy var fullDestPath = NSURL(fileURLWithPath: destPath)
        .appendingPathComponent(Sundeed.shared.databaseFileName)
    func getConnection(toWrite: Bool = false) throws -> OpaquePointer? {
        try createDatabaseIfNeeded()
        let fileURL = try FileManager
            .default.url(for: .documentDirectory,
                         in: .userDomainMask,
                         appropriateFor: nil,
                         create: false)
            .appendingPathComponent(Sundeed.shared.databaseFileName)
        var database: OpaquePointer?
        let flags = toWrite ?
            SQLITE_OPEN_READWRITE|SQLITE_OPEN_FULLMUTEX :
            SQLITE_OPEN_READWRITE|SQLITE_OPEN_FULLMUTEX
        if sqlite3_open_v2(fileURL.path,
                           &database,
                           flags,
                           nil) != SQLITE_OK {
            throw SundeedQLiteError.errorInConnection
        }
        return database
    }
    func closeConnection(database: OpaquePointer?) {
        let rc2 = sqlite3_close(database)
        if rc2 == SQLITE_BUSY {
            while let stmt = sqlite3_next_stmt(database, nil) {
                sqlite3_finalize(stmt)
            }
            closeConnection(database: database)
        }
    }
    func execute(query: String?, parameters: [ParameterType]? = nil, force: Bool = false, completion: (()->Void)? = nil) {
        guard let query = query else {
            completion?()
            return
        }
        Sundeed.shared.backgroundQueue.async {
            do {
                if self.canExecute || force {
                    var writeConnection = try self.getConnection(toWrite: true)
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
                            sqlite3_finalize(statement)
                            self.sqlStatements.insert((query, parameters, completion), at: 0)
                        }
                    } else {
                        if prepare != SQLITE_ERROR {
                            sqlite3_finalize(statement)
                            self.sqlStatements.insert((query, parameters, completion), at: 0)
                        }
                    }
                    let combination = self.sqlStatements.popLast()
                    if let oldQuery = combination?.0 {
                        self.closeConnection(database: writeConnection)
                        statement = nil
                        writeConnection = nil
                        self.execute(query: oldQuery, parameters: combination?.1, force: true, completion: combination?.2)
                    } else {
                        completion?()
                        self.closeConnection(database: writeConnection)
                        statement = nil
                        writeConnection = nil
                        self.canExecute = true
                    }
                } else {
                    self.sqlStatements.insert((query, parameters, completion), at: 0)
                }
            } catch {
                self.sqlStatements.insert((query, parameters, completion), at: 0)
            }
        }
    }
    func deleteDatabase() {
        guard let fullDestinationPath = fullDestPath else { return }
        self.sqlStatements.removeAll()
        try? fileManager.removeItem(at: fullDestinationPath)
    }
    private func createDatabaseIfNeeded() throws {
        guard let fullDestinationPath = fullDestPath else { return }
        let fullDestPathString = fullDestPath!.path
        if !fileManager.fileExists(atPath: fullDestPathString) {
            try "".write(to: fullDestinationPath, atomically: false, encoding: .utf8)
        }
    }
}
