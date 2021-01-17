//
//  SundeedQLiteConnection.swift
//  SQLiteLibrary
//
//  Created by Nour Sandid on 12/9/18.
//  Copyright © 2018 LUMBERCODE. All rights reserved.
//

import UIKit
import SQLite3

class SundeedQLiteConnection {
    static var pool: SundeedQLiteConnection = SundeedQLiteConnection()
    var sqlStatements: [(String, (()->Void)?)] = []
    var canExecute: Bool = true
    let fileManager = FileManager.default
    let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                       .userDomainMask,
                                                       true).first!
    lazy var fullDestPath = NSURL(fileURLWithPath: destPath)
        .appendingPathComponent(Sundeed.shared.databaseFileName)
    func getConnection(toWrite: Bool = false) throws -> OpaquePointer? {
        moveDatabaseToFilePath()
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
    func execute(query: String?, force: Bool = false, completion: (()->Void)? = nil) {
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
                        if sqlite3_step(statement) == SQLITE_DONE {
                            sqlite3_finalize(statement)
                        } else {
                            sqlite3_finalize(statement)
                            self.sqlStatements.insert((query, completion), at: 0)
                        }
                    } else {
                        if prepare != SQLITE_ERROR {
                            sqlite3_finalize(statement)
                            self.sqlStatements.insert((query, completion), at: 0)
                        }
                    }
                    let combination = self.sqlStatements.popLast()
                    if let oldQuery = combination?.0 {
                        self.closeConnection(database: writeConnection)
                        statement = nil
                        writeConnection = nil
                        self.execute(query: oldQuery, force: true, completion: combination?.1)
                    } else {
                        completion?()
                        self.closeConnection(database: writeConnection)
                        statement = nil
                        writeConnection = nil
                        self.canExecute = true
                    }
                } else {
                    self.sqlStatements.insert((query, completion), at: 0)
                }
            } catch {
                self.sqlStatements.insert((query, completion), at: 0)
            }
        }
    }
    func deleteDatabase() {
        guard let fullDestinationPath = fullDestPath else { return }
        UserDefaults.standard.set(true,
                                  forKey: Sundeed.shared.shouldCopyDatabaseToFilePathKey)
        self.sqlStatements.removeAll()
        try? fileManager.removeItem(at: fullDestinationPath)
    }
    private func moveDatabaseToFilePath(force: Bool = false) {
        if self.shouldCopyDatabaseToFilePath() || force {
            guard let fullDestinationPath = fullDestPath else { return }
            let fullDestPathString = fullDestPath!.path
            if !fileManager.fileExists(atPath: fullDestPathString) {
                try? "".write(to: fullDestinationPath, atomically: false, encoding: .utf8)
                moveDatabaseToFilePath(force: true)
            }
        }
    }
    /**  returns if we should copy the database to the files again */
    private func shouldCopyDatabaseToFilePath() -> Bool {
        let shouldCopy = (UserDefaults.standard
        .value(forKey: Sundeed.shared.shouldCopyDatabaseToFilePathKey) as? Bool) ?? true
        if shouldCopy {
            UserDefaults.standard
                .set(false, forKey: Sundeed.shared.shouldCopyDatabaseToFilePathKey)
            return true
        }
        return false
    }
}
