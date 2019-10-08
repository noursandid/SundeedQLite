//
//  SundeedQLiteConnectionPool.swift
//  SQLiteLibrary
//
//  Created by Nour Sandid on 12/9/18.
//  Copyright © 2018 LUMBERCODE. All rights reserved.
//

import UIKit
import SQLite3

class SundeedQLiteConnectionPool{
    private var sqlStatements:[String] = []
    private var canExecute:Bool = true
    fileprivate let globalBackgroundSyncronizeDataQueue = DispatchQueue(
        label: "globalBackgroundSyncronizeSharedData")
    func getConnection(toWrite:Bool = false) throws -> OpaquePointer?{
        moveDatabaseToFilePath()
        if toWrite {
            let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("SQLiteDB.sqlite")
            var database: OpaquePointer?
            if sqlite3_open_v2(fileURL.path, &database,SQLITE_OPEN_READWRITE|SQLITE_OPEN_FULLMUTEX,nil) != SQLITE_OK {
                throw SundeedQLiteError.ErrorInConnection
            }
            return database
        }
        else{
            let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("SQLiteDB.sqlite")
            var database: OpaquePointer?
            if sqlite3_open_v2(fileURL.path, &database,SQLITE_OPEN_READONLY,nil) != SQLITE_OK {
                throw SundeedQLiteError.ErrorInConnection
            }
            return database
        }
    }
    func closeConnection(database:OpaquePointer?){
        let rc2 = sqlite3_close(database)
        if rc2 == SQLITE_BUSY {
            while let stmt = sqlite3_next_stmt(database,nil)
            {
                let _ = sqlite3_finalize(stmt)
            }
            sqlite3_close(database)
        }
    }
    func execute(query:String,force:Bool = false){
        globalBackgroundSyncronizeDataQueue.async {
            do{
                if self.canExecute || force{
                    var writeConnection = try self.getConnection(toWrite: true)
                    self.canExecute = false
                    var statement: OpaquePointer?
                    let prepare = sqlite3_prepare_v2(writeConnection, query, -1, &statement, nil)
                    if  prepare == SQLITE_OK {
                        if sqlite3_step(statement) == SQLITE_DONE {
                            sqlite3_finalize(statement)
                        } else {
                            sqlite3_finalize(statement)
                            self.sqlStatements.insert(query, at: 0)
                        }
                    }
                    else{
                        if prepare != SQLITE_ERROR {
                            sqlite3_finalize(statement)
                            self.sqlStatements.insert(query, at: 0)
                        }
                    }
                    let oldQuery = self.sqlStatements.popLast()
                    if oldQuery != nil {
                        self.closeConnection(database: writeConnection)
                        statement = nil
                        writeConnection = nil
                        self.execute(query: oldQuery!,force: true)
                    }
                    else{
                        self.closeConnection(database: writeConnection)
                        statement = nil
                        writeConnection = nil
                        self.canExecute = true
                    }
                }
                else{
                    self.sqlStatements.insert(query, at: 0)
                }
            }
            catch{
                self.sqlStatements.insert(query, at: 0)
            }
        }
    }
    
    func deleteDatabase(){
        let filemManager = FileManager.default
        do {
            let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let fullDestPath = NSURL(fileURLWithPath: destPath).appendingPathComponent("SQLiteDB.sqlite")
            if fullDestPath != nil {
                UserDefaults.standard.set(true, forKey: "shouldCopyDatabaseToFilePath")
                self.sqlStatements.removeAll()
                try filemManager.removeItem(at: fullDestPath!)
            }
            else{
            }
        } catch {}
    }
    private func moveDatabaseToFilePath(force: Bool = false){
        if self.shouldCopyDatabaseToFilePath() || force{
            let fileManager = FileManager.default
            let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let fullDestPath = NSURL(fileURLWithPath: destPath).appendingPathComponent("SQLiteDB.sqlite")
            if fullDestPath != nil {
                let fullDestPathString = fullDestPath!.path
                if !fileManager.fileExists(atPath: fullDestPathString) {
                    do {
                        let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                        let fullDestPath = NSURL(fileURLWithPath: destPath).appendingPathComponent("SQLiteDB.sqlite")
                        guard let fullDestinationPath = fullDestPath else { return }
                        try "".write(to: fullDestinationPath, atomically: false, encoding: .utf8)
                        moveDatabaseToFilePath(force: true)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    /**  returns if we should copy the database to the files again */
    private func shouldCopyDatabaseToFilePath()->Bool{
        if let shouldCopy = UserDefaults.standard.value(forKey: "shouldCopyDatabaseToFilePath") as? Bool {
            if shouldCopy {
                UserDefaults.standard.set(false, forKey: "shouldCopyDatabaseToFilePath")
                return true
            }
            else{
                return false
            }
        }
        else{
            UserDefaults.standard.set(false, forKey: "shouldCopyDatabaseToFilePath")
            return true
        }
    }
}

