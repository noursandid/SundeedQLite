//
//  SundeedQLite.swift
//  SQLiteLibrary
//
//  Created by Nour Sandid on 12/9/18.
//  Copyright © 2018 LUMBERCODE. All rights reserved.
//

import UIKit
import SQLite3

class SundeedQLite {
    public static var instance:SundeedQLite = SundeedQLite()
    private static var tables:[String] = []
    fileprivate static var connectionPool:SundeedQLiteConnectionPool = SundeedQLiteConnectionPool()
    fileprivate let globalBackgroundSyncronizeDataQueue = DispatchQueue(
        label: "globalBackgroundSyncronizeSharedData")
    fileprivate var dateFormatter:DateFormatter = DateFormatter()
    
    /** Checks if the object is of an acceptable type */
    private func acceptDataType(forObject object:AnyObject?)->Bool{
        if object != nil {
            return object is String || object is String? || object is Int || object is Int? || object is Double || object is Double? || object is Float || object is Float? || object is Bool || object is Bool? || object is Date || object is Date? || object is UIImage || object is UIImage?
        }
        else{
            return false
        }
    }
    /** Converts the swift datatype to sqlite datatype */
    private func convertTypeToSQL(object: SundeedQLiter,attribute:AnyObject?) throws ->String{
        if attribute is SundeedQLiter || attribute is [SundeedQLiter] || attribute is SundeedQLiter? || attribute is [SundeedQLiter]? || attribute is [SundeedQLiter?]? || attribute is String || attribute is Date || attribute is Date? || attribute is String? || attribute is Int || attribute is Bool || attribute is Int? || attribute is Bool? || attribute is Double || attribute is Float || attribute is Double? || attribute is Float? || attribute is UIImage || attribute is UIImage?{
            return "TEXT"
        }
        else {
            throw SundeedQLiteError.UnsupportedType(object: object, attribute: "\(type(of: attribute))")
        }
    }
    
    /** Try to create table if not already exists */
    private func createTable(forObject obj:Any?,withForeignKey foreignKey:Bool = false) throws{
        if let object = obj as? SundeedQLiter {
            if  !SundeedQLite.tables.contains(object.getTableName()){
                let map = SundeedQLiteMap(fetchingColumns: true)
                object.sundeedQLiterMapping(map: map)
                var createTableStatement = "CREATE TABLE IF NOT EXISTS \(object.getTableName()) (SUNDEED_OFFLINE_ID INTEGER PRIMARY KEY, SUNDEED_FOREIGN_KEY TEXT"
                for (columnName,attribute) in map.columns{
                    if attribute is SundeedQLiter {
                        try createTable(forObject: ((attribute as! SundeedQLiter)))
                        createTableStatement += ",\(columnName) TEXT"
                    }
                    else if attribute is [SundeedQLiter?] {
                        if (attribute as! [SundeedQLiter?]).count > 0 {
                            try createTable(forObject: ((attribute as! [Swift.Optional<SundeedQLiter>]).first!))
                        }
                        createTableStatement += ",\(columnName) TEXT"
                    }
                    else if attribute is [String?] {
                        if (attribute as! [String?]).compactMap({$0}).count > 0 {
                            try createTableForPrimitiveDataTypes(withTableName: columnName)
                        }
                        createTableStatement += ",\(columnName) TEXT"
                    }
                    else if attribute is [Int?] {
                        if (attribute as! [Int?]).compactMap({$0}).count > 0 {
                            try createTableForPrimitiveDataTypes(withTableName: columnName)
                        }
                        createTableStatement += ",\(columnName) TEXT"
                    }
                    else if attribute is [Double?] {
                        if (attribute as! [Double?]).compactMap({$0}).count > 0 {
                            try createTableForPrimitiveDataTypes(withTableName: columnName)
                        }
                        createTableStatement += ",\(columnName) TEXT"
                    }
                    else if attribute is [Float?] {
                        if (attribute as! [Float?]).compactMap({$0}).count > 0 {
                            try createTableForPrimitiveDataTypes(withTableName: columnName)
                        }
                        createTableStatement += ",\(columnName) TEXT"
                    }
                    else if attribute is [Date?] {
                        if (attribute as! [Date?]).compactMap({$0}).count > 0 {
                            try createTableForPrimitiveDataTypes(withTableName: columnName)
                        }
                        createTableStatement += ",\(columnName) TEXT"
                    }
                    else if attribute is [Bool?] {
                        if (attribute as! [Bool?]).compactMap({$0}).count > 0 {
                            try createTableForPrimitiveDataTypes(withTableName: columnName)
                        }
                        createTableStatement += ",\(columnName) TEXT"
                    }
                    else if attribute is [UIImage?] {
                        if (attribute as! [UIImage?]).compactMap({$0}).count > 0 {
                            try createTableForPrimitiveDataTypes(withTableName: columnName)
                        }
                        createTableStatement += ",\(columnName) TEXT"
                    }
                    else if acceptDataType(forObject: attribute as AnyObject) {
                        if columnName == "index" {
                            throw SundeedQLiteError.CantUseNameIndex(object: object)
                        }
                        if columnName == map.primaryKey{
                            createTableStatement += ",\(columnName) \(try convertTypeToSQL(object: object, attribute: attribute))"
                        }
                        else{
                            createTableStatement += ",\(columnName) \(try convertTypeToSQL(object: object, attribute: attribute))"
                        }
                    }
                    else{
                        throw SundeedQLiteError.UnsupportedType(object: object, attribute: "\(type(of: attribute))")
                    }
                }
                if map.hasPrimaryKey {
                    createTableStatement += ",CONSTRAINT unq\(object.getTableName()) UNIQUE (SUNDEED_FOREIGN_KEY, \(map.primaryKey))"
                }
                createTableStatement += ")"
                SundeedQLite.connectionPool.execute(query:createTableStatement)
                SundeedQLite.tables.append(object.getTableName())
            }
        }
    }
    
    func retrieve(forClass sundeedClass:AnyClass,withFilter filter:SundeedExpression<Bool>? = nil,orderBy order:SundeedColumn? = nil,ascending asc:Bool = true,completion:((_ data:[SundeedQLiter])->Void)?){
        globalBackgroundSyncronizeDataQueue.async {
            if let sundeed = sundeedClass as? SundeedQLiter.Type {
                var objectsArray:[SundeedQLiter] = []
                let dictionnariesArray = self.getDictionaryValues(forClass: sundeedClass,withFilter: filter)
                for dictionnary in dictionnariesArray {
                    let object = sundeed.init()
                    let map = SundeedQLiteMap(dictionnary: dictionnary)
                    object.sundeedQLiterMapping(map: map)
                    if map.isSafeToAdd {
                        objectsArray.append(object)
                    }
                }
                if order != nil && objectsArray.count > 0{
                    objectsArray.sort { (object1, object2) -> Bool in
                        if !asc {
                            if object1[order!.value] is String? {
                                return (object1[order!.value] as! String) > (object2[order!.value] as! String)
                            }
                            else if object1[order!.value] is Int?{
                                return (object1[order!.value] as! Int) > (object2[order!.value] as! Int)
                            }
                            else if object1[order!.value] is Date?{
                                return (object1[order!.value] as! Date) > (object2[order!.value] as! Date)
                            }
                            else{
                                return false
                            }
                        }
                        else{
                            if object1[order!.value] is String? {
                                return (object1[order!.value] as! String) < (object2[order!.value] as! String)
                            }
                            else if object1[order!.value] is Int?{
                                return (object1[order!.value] as! Int) < (object2[order!.value] as! Int)
                            }
                            else if object1[order!.value] is Date?{
                                return (object1[order!.value] as! Date) < (object2[order!.value] as! Date)
                            }
                            else{
                                return false
                            }
                        }
                    }
                }
                completion?(objectsArray)
            }
        }
    }
    func save(objects:[SundeedQLiter],withForeignKey foreignKey:String? = nil){
        globalBackgroundSyncronizeDataQueue.async {
            do {
                try self.createTable(forObject: objects.first)
                
                for object in objects {
                    
                    let map = SundeedQLiteMap(fetchingColumns: true)
                    object.sundeedQLiterMapping(map: map)
                    var insertStatement:String = "REPLACE INTO \(object.getTableName()) (SUNDEED_FOREIGN_KEY,"
                    var values = "\(foreignKey == nil ? "\"\"," : "\"\(foreignKey!)\",")"
                    var index = 0
                    for (columnName,attribute) in map.columns{
                        if attribute is SundeedQLiter {
                            insertStatement += "\(index==0 ? "" : ",")\(columnName)"
                            values += "\(index==0 ? "" : ",")\"SUNDEED_FOREIGN|\((attribute as! SundeedQLiter))\""
                            if map.hasPrimaryKey {
                                self.save(objects: [attribute as! SundeedQLiter],withForeignKey: String(describing: map.columns[map.primaryKey] as AnyObject))
                            }
                            else{
                                throw SundeedQLiteError.PrimaryKeyError(object: object)
                            }
                            index += 1
                        }
                        else if attribute is [SundeedQLiter?]{
                            if (attribute as! [SundeedQLiter?]).compactMap({$0}).count > 0 {
                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
                                values += "\(index==0 ? "" : ",")\"SUNDEED_FOREIGN|\((attribute as! [SundeedQLiter?]).compactMap({$0}).first!)\""
                                if map.hasPrimaryKey {
                                    self.save(objects: (attribute as! [SundeedQLiter?]).compactMap({$0}),withForeignKey:String(describing:      map.columns[map.primaryKey] as AnyObject))
                                }
                                else{
                                    throw SundeedQLiteError.PrimaryKeyError(object: object)
                                }
                                index += 1
                            }
                            else{
                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
                                values += "\(index==0 ? "" : ",")\"\""
                                index += 1
                            }
                        }
                        else if attribute is UIImage{
                            insertStatement += "\(index==0 ? "" : ",")\(columnName)"
                            values += "\(index==0 ? "" : ",")\"\((attribute as! UIImage).dataTypeValue(forObjectID: map.columns[map.primaryKey] as! String))\""
                            index += 1
                        }
                        else if attribute is Date{
                            self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                            insertStatement += "\(index==0 ? "" : ",")\(columnName)"
                            values += "\(index==0 ? "" : ",")\"\(self.dateFormatter.string(from:attribute as! Date))\""
                            index += 1
                        }
                        else if attribute is [String?]{
                            if (attribute as! [String?]).compactMap({$0}).count > 0 {
                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
                                values += "\(index==0 ? "" : ",")\"SUNDEED_PRIMITIVE_FOREIGN|\(columnName)\""
                                if map.hasPrimaryKey {
                                    self.saveArrayOfPrimitives(tableName: columnName, objects: attribute as! [String?], withForeignKey: String(describing:      map.columns[map.primaryKey] as AnyObject))
                                }
                                else{
                                    throw SundeedQLiteError.PrimaryKeyError(object: object)
                                }
                                index += 1
                            }
                            else{
                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
                                values += "\(index==0 ? "" : ",")\"\""
                                index += 1
                            }
                        }
                        else if attribute is [Int?]{
                            if (attribute as! [Int?]).compactMap({$0}).count > 0 {
                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
                                values += "\(index==0 ? "" : ",")\"SUNDEED_PRIMITIVE_FOREIGN|\(columnName)\""
                                if map.hasPrimaryKey {
                                    self.saveArrayOfPrimitives(tableName: columnName, objects: attribute as! [Int?], withForeignKey: String(describing:      map.columns[map.primaryKey] as AnyObject))
                                }
                                else{
                                    throw SundeedQLiteError.PrimaryKeyError(object: object)
                                }
                                index += 1
                            }
                            else{
                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
                                values += "\(index==0 ? "" : ",")\"\""
                                index += 1
                            }
                        }
                        else if attribute is [Double?]{
                            if (attribute as! [Double?]).compactMap({$0}).count > 0 {
                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
                                values += "\(index==0 ? "" : ",")\"SUNDEED_PRIMITIVE_FOREIGN|\(columnName)\""
                                if map.hasPrimaryKey {
                                    self.saveArrayOfPrimitives(tableName: columnName, objects: attribute as! [Double?], withForeignKey: String(describing:      map.columns[map.primaryKey] as AnyObject))
                                }
                                else{
                                    throw SundeedQLiteError.PrimaryKeyError(object: object)
                                }
                                index += 1
                            }
                            else{
                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
                                values += "\(index==0 ? "" : ",")\"\""
                                index += 1
                            }
                        }
                        else if attribute is [Float?]{
                            if (attribute as! [Float?]).compactMap({$0}).count > 0 {
                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
                                values += "\(index==0 ? "" : ",")\"SUNDEED_PRIMITIVE_FOREIGN|\(columnName)\""
                                if map.hasPrimaryKey {
                                    self.saveArrayOfPrimitives(tableName: columnName, objects: attribute as! [Float?], withForeignKey: String(describing:      map.columns[map.primaryKey] as AnyObject))
                                }
                                else{
                                    throw SundeedQLiteError.PrimaryKeyError(object: object)
                                }
                                index += 1
                            }
                            else{
                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
                                values += "\(index==0 ? "" : ",")\"\""
                                index += 1
                            }
                        }
                        else if attribute is [Date?]{
                            if (attribute as! [Date?]).compactMap({$0}).count > 0 {
                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
                                values += "\(index==0 ? "" : ",")\"SUNDEED_PRIMITIVE_FOREIGN|\(columnName)\""
                                if map.hasPrimaryKey {
                                    self.saveArrayOfPrimitives(tableName: columnName, objects: attribute as! [Date?], withForeignKey: String(describing:      map.columns[map.primaryKey] as AnyObject))
                                }
                                else{
                                    throw SundeedQLiteError.PrimaryKeyError(object: object)
                                }
                                index += 1
                            }
                            else{
                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
                                values += "\(index==0 ? "" : ",")\"\""
                                index += 1
                            }
                        }
                        else if attribute is [Bool?]{
                            if (attribute as! [Bool?]).compactMap({$0}).count > 0 {
                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
                                values += "\(index==0 ? "" : ",")\"SUNDEED_PRIMITIVE_FOREIGN|\(columnName)\""
                                if map.hasPrimaryKey {
                                    self.saveArrayOfPrimitives(tableName: columnName, objects: attribute as! [String], withForeignKey: String(describing:      map.columns[map.primaryKey] as AnyObject))
                                }
                                else{
                                    throw SundeedQLiteError.PrimaryKeyError(object: object)
                                }
                                index += 1
                            }
                            else{
                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
                                values += "\(index==0 ? "" : ",")\"\""
                                index += 1
                            }
                        }
                        else if attribute is [UIImage?]{
                            if (attribute as! [UIImage?]).compactMap({$0}).count > 0 {
                                let attribute = (attribute as? [UIImage?])?.compactMap({$0?.dataTypeValue(forObjectID: "\(String(describing: map.columns[map.primaryKey] as AnyObject))\(columnName)\(String(describing: (attribute as! [UIImage?]).compactMap({$0}).firstIndex(of: $0)!))")})
                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
                                values += "\(index==0 ? "" : ",")\"SUNDEED_PRIMITIVE_FOREIGN|\(columnName)\""
                                if map.hasPrimaryKey {
                                    self.saveArrayOfPrimitives(tableName: columnName, objects: attribute!, withForeignKey: String(describing: map.columns[map.primaryKey] as AnyObject))
                                }
                                else{
                                    throw SundeedQLiteError.PrimaryKeyError(object: object)
                                }
                                index += 1
                            }
                            else{
                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
                                values += "\(index==0 ? "" : ",")\"\""
                                index += 1
                            }
                        }
                        else if self.acceptDataType(forObject: attribute as AnyObject){
                            insertStatement += "\(index==0 ? "" : ",")\(columnName)"
                            if String(describing:attribute as AnyObject).contains("\""){
                                values += "\(index==0 ? "" : ",")\'\(attribute as AnyObject)\'"
                            }
                            else{
                                values += "\(index==0 ? "" : ",")\"\(attribute as AnyObject)\""
                            }
                            index += 1
                        }
                    }
                    insertStatement += ") VALUES (\(values));"
                    SundeedQLite.connectionPool.execute(query: insertStatement)
                }
            }
            catch{
                print(error)
            }
        }
    }
    
    /** Try to create table for primitive data types if not already exists */
    func createTableForPrimitiveDataTypes(withTableName tableName: String) throws{
        if  !SundeedQLite.tables.contains(tableName){
            let createTableStatement = "CREATE TABLE IF NOT EXISTS \(tableName) (SUNDEED_OFFLINE_ID INTEGER PRIMARY KEY ASC, SUNDEED_FOREIGN_KEY TEXT, VALUE TEXT)"
            SundeedQLite.connectionPool.execute(query:createTableStatement)
            SundeedQLite.tables.append(tableName)
        }
    }
    
    func saveArrayOfPrimitives<T>(tableName: String, objects:[T?],withForeignKey foreignKey:String){
        globalBackgroundSyncronizeDataQueue.async {
            do {
                try self.createTableForPrimitiveDataTypes(withTableName: tableName)
                try self.deleteFromDB(tableName: tableName, foreignKey: foreignKey)
                for string in objects.compactMap({$0}) {
                    let values = "\"\(foreignKey)\", \"\(String(describing: string))\""
                    let insertStatement:String = "REPLACE INTO \(tableName) (SUNDEED_FOREIGN_KEY, VALUE) VALUES (\(values));"
                    SundeedQLite.connectionPool.execute(query: insertStatement)
                }
            }
            catch {
                
            }
        }
    }
    
    func getDictionaryValues(forClass sundeedClass:AnyClass,withFilter filter:SundeedExpression<Bool>? = nil) ->[[String:Any]]{
        let table = "\(type(of: sundeedClass))".replacingOccurrences(of: ".Type", with: "")
        do {
            if let sundeed = sundeedClass as? SundeedQLiter.Type{
                var database = try SundeedQLite.connectionPool.getConnection()
                let map = SundeedQLiteMap(fetchingColumns: true)
                let instance = sundeed.init()
                instance.sundeedQLiterMapping(map: map)
                if let columns = getDatabaseColumns(forTable: table), columns.count > 0{
                    var array:[[String:Any]] = []
                    var statement: OpaquePointer?
                    
                    if sqlite3_prepare_v2(database, "SELECT * FROM \(table) \(filter != nil ? filter!.toWhereStatement() : "") ORDER BY \(map.isOrdered ? "\"\(map.orderBy)\" COLLATE NOCASE \(map.asc ? "ASC" : "DESC")" : "\"SUNDEED_OFFLINE_ID\" ASC");", -1, &statement, nil) != SQLITE_OK {
                       
                    }
                    
                    while sqlite3_step(statement) == SQLITE_ROW {
                        var dictionary:[String:Any] = [:]
                        var primaryKey:String!
                        for column in columns{
                            if let columnValue = sqlite3_column_text(statement, Int32(column.key)) {
                                let value:String = String(cString: columnValue)
                                if value != "<null>" {
                                    dictionary[column.value] = value.replacingOccurrences(of: "\\\"", with: "\"")
                                }
                            }
                        }
                        if map.hasPrimaryKey && columns.contains(where: { $0.value == map.primaryKey}) {
                            let column = columns.first { (column) -> Bool in
                                return column.value == map.primaryKey
                                }!
                            if let columnValue = sqlite3_column_text(statement, Int32(column.key)) {
                                let value:String = String(cString: columnValue)
                                primaryKey = value.replacingOccurrences(of: "\\\"", with: "\"")
                            }
                        }
                        for row in dictionary {
                            if let value = row.value as? String {
                                if value.starts(with: "SUNDEED_FOREIGN|"){
                                    let configurations = value.split(separator: "|")
                                    let embededElementTable = configurations[1]
                                    if map.hasPrimaryKey{
                                        dictionary[row.key] = self.getDictionaryValues(forClass: NSClassFromString(String(describing:embededElementTable))!,withFilter: SundeedColumn("SUNDEED_FOREIGN_KEY") == primaryKey)
                                    }
                                    else{
                                        throw SundeedQLiteError.PrimaryKeyError(object: instance)
                                    }
                                } else if value.starts(with: "SUNDEED_PRIMITIVE_FOREIGN|"){
                                    let configurations = value.split(separator: "|")
                                    let embededElementTable = configurations[1]
                                    if map.hasPrimaryKey{
                                        dictionary[row.key] = self.getDictionaryValuesForPrimitives(forTable: String(embededElementTable),withFilter: (SundeedColumn("SUNDEED_FOREIGN_KEY") == primaryKey)!)
                                    }
                                    else{
                                        throw SundeedQLiteError.PrimaryKeyError(object: instance)
                                    }
                                }
                            }
                        }
                        array.append(dictionary)
                    }
                    SundeedQLite.connectionPool.closeConnection(database: database)
                    statement = nil
                    database = nil
                    return array
                }
                else{
                    database = nil
                    return []
                }
                
            }else{
                return []
            }
            
        }
        catch{
            return []
        }
    }
    
    func getDictionaryValuesForPrimitives(forTable table: String, withFilter filter: SundeedExpression<Bool>) -> [String]?{
        do {
            let database = try SundeedQLite.connectionPool.getConnection()
            var statement: OpaquePointer?
            if sqlite3_prepare_v2(database, "SELECT * FROM \(table) \(filter.toWhereStatement()) ORDER BY \"SUNDEED_OFFLINE_ID\" ASC;", -1, &statement, nil) == SQLITE_OK,
                let columns = getDatabaseColumns(forTable: table) {
                var array: [String] = []
                for column in columns where column.value == "VALUE" {
                    while sqlite3_step(statement) == SQLITE_ROW {
                        if let columnValue = sqlite3_column_text(statement, Int32(column.key)) {
                            let value:String = String(cString: columnValue)
                            if value != "<null>" {
                                array.append(value.replacingOccurrences(of: "\\\"", with: "\""))
                            }
                        }
                    }
                }
                return array
            }
        } catch {
        }
        return nil
    }
    
    private func getDatabaseColumns(forTable table:String)->[Int:String]?{
        do {
            if let database = try SundeedQLite.connectionPool.getConnection(toWrite: true) {
                var columnsStatement: OpaquePointer?
                var dictionary:[Int:String] = [:]
                if sqlite3_prepare_v2(database, "PRAGMA table_info(\(table));", -1, &columnsStatement, nil) != SQLITE_OK {
                    
                }
                var index = 0
                while sqlite3_step(columnsStatement) == SQLITE_ROW {
                    if let columnName = sqlite3_column_text(columnsStatement, 1) {
                        let name = String(cString: columnName)
                        dictionary[index] = name
                        index += 1
                    } else {}
                }
                columnsStatement = nil
                SundeedQLite.connectionPool.closeConnection(database: database)
                return dictionary
            }
            else{
                return nil
            }
        }
        catch{
            return nil
        }
    }
    func update(obj:Any?,columns:[SundeedColumn]){
        //        DispatchQueue.global().async {
        do {
            if let object = obj as? SundeedQLiter {
                try self.createTable(forObject: object)
                //                    let db = try SundeedQLite.connectionPool.getConnectionToWrite()
                let map = SundeedQLiteMap(fetchingColumns: true)
                object.sundeedQLiterMapping(map: map)
                if !map.hasPrimaryKey {
                    throw SundeedQLiteError.PrimaryKeyError(object: object)
                }
                var updateStatement = "UPDATE \(object.getTableName()) SET "
                var index = 0
                for column in columns {
                    if map.columns.contains(where: { (arg0) -> Bool in
                        let (key,_) = arg0
                        return key == column.value
                    }){
                        let attribute = map.columns[column.value]
                        if attribute is SundeedQLiter {
                            if attribute != nil{
                                if map.hasPrimaryKey {
                                    self.save(objects: [attribute as! SundeedQLiter],withForeignKey: String(describing: map.columns[map.primaryKey] as AnyObject))
                                }
                                else{
                                    throw SundeedQLiteError.PrimaryKeyError(object: object)
                                }
                                updateStatement += "\(index != 0 ? "," : "")\(column.value) = \"SUNDEED_FOREIGN|\((attribute as! SundeedQLiter))\" "
                            }
                            
                        }
                        else if attribute is [SundeedQLiter]{
                            if (attribute as! [SundeedQLiter]).count > 0 {
                                if map.hasPrimaryKey {
                                    self.save(objects: attribute as! [SundeedQLiter],withForeignKey:String(describing:      map.columns[map.primaryKey] as AnyObject))
                                }
                                else{
                                    throw SundeedQLiteError.PrimaryKeyError(object: object)
                                }
                                updateStatement += "\(index != 0 ? "," : "")\(column.value) = \"SUNDEED_FOREIGN|\((attribute as! [SundeedQLiter]).first!)\" "
                                index += 1
                            }
                        }
                        else if attribute is [String] {
                            if (attribute as! [String]).count > 0 {
                                if map.hasPrimaryKey {
                                    self.saveArrayOfPrimitives(tableName: column.value, objects: attribute as! [String], withForeignKey: String(describing:      map.columns[map.primaryKey] as AnyObject))
                                }
                                else{
                                    throw SundeedQLiteError.PrimaryKeyError(object: object)
                                }
                                updateStatement += "\(index != 0 ? "," : "")\(column.value) = \"SUNDEED_PRIMITIVE_FOREIGN|\(column.value)\" "
                                index += 1
                            }
                        }
                        else if attribute is [Int] {
                            if (attribute as! [Int]).count > 0 {
                                if map.hasPrimaryKey {
                                    self.saveArrayOfPrimitives(tableName: column.value, objects: attribute as! [Int], withForeignKey: String(describing:      map.columns[map.primaryKey] as AnyObject))
                                }
                                else{
                                    throw SundeedQLiteError.PrimaryKeyError(object: object)
                                }
                                updateStatement += "\(index != 0 ? "," : "")\(column.value) = \"SUNDEED_PRIMITIVE_FOREIGN|\(column.value)\" "
                                index += 1
                            }
                        }
                        else if attribute is [Double] {
                            if (attribute as! [Double]).count > 0 {
                                if map.hasPrimaryKey {
                                    self.saveArrayOfPrimitives(tableName: column.value, objects: attribute as! [Double], withForeignKey: String(describing:      map.columns[map.primaryKey] as AnyObject))
                                }
                                else{
                                    throw SundeedQLiteError.PrimaryKeyError(object: object)
                                }
                                updateStatement += "\(index != 0 ? "," : "")\(column.value) = \"SUNDEED_PRIMITIVE_FOREIGN|\(column.value)\" "
                                index += 1
                            }
                        }
                        else if attribute is [Float] {
                            if (attribute as! [Float]).count > 0 {
                                if map.hasPrimaryKey {
                                    self.saveArrayOfPrimitives(tableName: column.value, objects: attribute as! [Float], withForeignKey: String(describing:      map.columns[map.primaryKey] as AnyObject))
                                }
                                else{
                                    throw SundeedQLiteError.PrimaryKeyError(object: object)
                                }
                                updateStatement += "\(index != 0 ? "," : "")\(column.value) = \"SUNDEED_PRIMITIVE_FOREIGN|\(column.value)\" "
                                index += 1
                            }
                        }
                        else if attribute is [Date] {
                            if (attribute as! [Date]).count > 0 {
                                if map.hasPrimaryKey {
                                    self.saveArrayOfPrimitives(tableName: column.value, objects: attribute as! [Date], withForeignKey: String(describing:      map.columns[map.primaryKey] as AnyObject))
                                }
                                else{
                                    throw SundeedQLiteError.PrimaryKeyError(object: object)
                                }
                                updateStatement += "\(index != 0 ? "," : "")\(column.value) = \"SUNDEED_PRIMITIVE_FOREIGN|\(column.value)\" "
                                index += 1
                            }
                        }
                        else if attribute is [UIImage] {
                            if (attribute as! [UIImage]).count > 0 {
                                let attribute = (attribute as? [UIImage])?.map({$0.dataTypeValue(forObjectID: "\(String(describing: map.columns[map.primaryKey] as AnyObject))\(column.value)\(String(describing: (attribute as! [UIImage]).firstIndex(of: $0)!))")})
                                if map.hasPrimaryKey {
                                    self.saveArrayOfPrimitives(tableName: column.value, objects: attribute! , withForeignKey: String(describing:      map.columns[map.primaryKey] as AnyObject))
                                }
                                else{
                                    throw SundeedQLiteError.PrimaryKeyError(object: object)
                                }
                                updateStatement += "\(index != 0 ? "," : "")\(column.value) = \"SUNDEED_PRIMITIVE_FOREIGN|\(column.value)\" "
                                index += 1
                            }
                        }
                        else if attribute is UIImage{
                            updateStatement += "\(index != 0 ? "," : "")\(column.value) = \"\((attribute as! UIImage).dataTypeValue(forObjectID: map.columns[map.primaryKey] as! String))\" "
                            index += 1
                        }
                        else if attribute is Date{
                            self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                            updateStatement += "\(index != 0 ? "," : "")\(column.value) = \"\(self.dateFormatter.string(from:attribute as! Date))\" "
                            index += 1
                        }
                        else{
                            updateStatement += "\(index != 0 ? "," : "")\(column.value) = \"\(attribute ?? "" as AnyObject)\" "
                            index += 1
                        }
                    }
                    else{
                        throw SundeedQLiteError.NoColumnWithThisName(object: object, columnName: column.value)
                    }
                }
                updateStatement += "WHERE \(map.primaryKey) = \"\(map.columns[map.primaryKey]!)\""
                if index > 0 {
                    SundeedQLite.connectionPool.execute(query: updateStatement)
                }
            }
        }
        catch{}
    }
    func update(forClass sundeedClass:AnyClass,changes:[SundeedUpdateSetStatement],withFilter filter:SundeedExpression<Bool>?) throws ->Bool{
        if let sundeed = sundeedClass as? SundeedQLiter.Type {
            let map = SundeedQLiteMap(fetchingColumns: true)
            let object = sundeed.init()
            object.sundeedQLiterMapping(map: map)
            if changes.count == 0 {
                throw SundeedQLiteError.NoChangesMade(object: object)
            }
            var updateStatement = "UPDATE \(object.getTableName()) SET "
            var index = 0
            for change in changes {
                if map.columns.contains(where: { (column) -> Bool in
                    return change.column.value == column.key
                }){
                    updateStatement += "\(index != 0 ? "," : "")\(change.column.value) = \"\(change.value)\" "
                    index += 1
                }
                else{
                    throw SundeedQLiteError.NoColumnWithThisName(object: object, columnName: change.column.value)
                }
            }
            if filter != nil {
                updateStatement += "WHERE \(filter!.toQuery());"
            } else {
                updateStatement += ";"
            }
            
            if index > 0 {
                //                try db.execute(updateStatement)
                SundeedQLite.connectionPool.execute(query: updateStatement)
            }
            return true
        }
        return false
    }
    func deleteFromDB(obj:Any?)throws ->Bool{
        if let object = obj as? SundeedQLiter {
            let map = SundeedQLiteMap(fetchingColumns: true)
            object.sundeedQLiterMapping(map: map)
            if map.hasPrimaryKey {
                let deleteStatement = "DELETE FROM \(object.getTableName()) WHERE \(map.primaryKey) = \"\(map.columns[map.primaryKey]!)\""
                SundeedQLite.connectionPool.execute(query: deleteStatement)
                return true
            }
            else{
                throw SundeedQLiteError.PrimaryKeyError(object: object)
            }
        }
        else{
            return false
        }
    }
    func deleteFromDB(tableName: String, foreignKey: String) throws {
        let deleteStatement = "DELETE FROM \(tableName) WHERE SUNDEED_FOREIGN_KEY = \"\(foreignKey)\""
        SundeedQLite.connectionPool.execute(query: deleteStatement)
    }
    func deleteAllFromDB(forClass sundeedClass:AnyClass,withFilter filter:SundeedExpression<Bool>? = nil)throws ->Bool{
        if let sundeed = sundeedClass as? SundeedQLiter.Type {
            let object = sundeed.init()
            let map = SundeedQLiteMap(fetchingColumns: true)
            object.sundeedQLiterMapping(map: map)
            if map.hasPrimaryKey {
                let deleteStatement = "DELETE FROM \(object.getTableName()) WHERE \(filter == nil ? "1" : filter!.toQuery())"
                SundeedQLite.connectionPool.execute(query: deleteStatement)
                return true
            }
            else{
                throw SundeedQLiteError.PrimaryKeyError(object: object)
            }
            
        }
        else{
            return false
        }
    }
    
    static func deleteDatabase(){
        SundeedQLite.tables.removeAll()
        SundeedQLite.connectionPool.deleteDatabase()
    }
}
extension UIImage {
    static func fromDatatypeValue(filePath : String) -> UIImage? {
        do {
            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectoryURL.appendingPathComponent(filePath)
            if FileManager.default.fileExists(atPath: fileURL.path) {
                let data = try Data(contentsOf: fileURL)
                return  UIImage(data: data)
            }
            else{
                return nil
            }
            
        }
        catch{
            return nil
        }
        
        
    }
    func dataTypeValue(forObjectID id:String)->String{
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectoryURL.appendingPathComponent("\(id).png")
            do {
                try self.pngData()!.write(to: fileURL)
            } catch {}
        return fileURL.lastPathComponent
    }
}
