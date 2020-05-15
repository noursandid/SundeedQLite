//
//  SundeedQLiteHandler.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/9/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation

class SundeedProcessor {
    typealias SundeedObject = [String: Any]
    
    func createTableIfNeeded(for object: SundeedObject?, mainTableName: String?) throws {
        guard let object = object,
            let mainTableName = mainTableName else { return }
        if !Sundeed.shared.tables.contains(mainTableName){
                let createTableStatement = SundeedStatementBuilder()
                    .createTableStatement(tableName: mainTableName)
                    
                for (columnName, attribute) in object {
                    if let attribute = attribute as? SundeedObject {
                        try createTableIfNeeded(for: attribute, mainTableName: columnName)
                    } else if let attribute = attribute as? [SundeedObject] {
                        if let firstAttribute = attribute.first {
                            try createTableIfNeeded(for: firstAttribute, mainTableName: columnName)
                        }
                    } else if attribute is Array<Any> {
                        createTableForPrimitiveDataTypes(withTableName: columnName)
                    }
                    createTableStatement.addColumn(with: columnName)
                    if columnName == "index" {
                        throw SundeedQLiteError.CantUseNameIndex(tableName: mainTableName)
                    }
                }
            if object[Sundeed.shared.primaryKey] != nil {
                createTableStatement.withPrimaryKey()
            }
            let query = createTableStatement.build()
            SundeedQLiteConnectionPool.pool.execute(query: query)
            Sundeed.shared.tables.append(mainTableName)
        }
    }
    
    /** Try to create table for primitive data types if not already exists */
    func createTableForPrimitiveDataTypes(withTableName tableName: String) {
        if  !Sundeed.shared.tables.contains(tableName){
            let createTableStatement = SundeedStatementBuilder()
                .createTableStatement(tableName: tableName)
                .addColumn(with: "VALUE")
                .build()
            SundeedQLiteConnectionPool.pool.execute(query:createTableStatement)
            Sundeed.shared.tables.append(tableName)
        }
    }
    
//    func save(objects:[SundeedObject],withForeignKey foreignKey:String? = nil){
//        Sundeed.shared.backgroundQueue.async {
//            do {
//                try self.createTable(forObject: objects.first)
//                for object in objects {
//                    let map = SundeedQLiteMap(fetchingColumns: true)
//                    object.sundeedQLiterMapping(map: map)
//                    var insertStatement:String = "REPLACE INTO \(object.getTableName()) (SUNDEED_FOREIGN_KEY,"
//                    var values = "\(foreignKey == nil ? "\"\"," : "\"\(foreignKey!)\",")"
//                    var index = 0
//                    for (columnName,attribute) in map.columns{
//                        if let attribute = attribute as? SundeedQLiter {
//                            insertStatement += "\(index==0 ? "" : ",")\(columnName)"
//                            values += "\(index==0 ? "" : ",")\"SUNDEED_FOREIGN|\(attribute)\""
//                            if map.hasPrimaryKey {
//                                self.save(objects: [attribute],withForeignKey: String(describing: map.columns[map.primaryKey] as AnyObject))
//                            } else {
//                                throw SundeedQLiteError.PrimaryKeyError(object: object)
//                            }
//                            index += 1
//                        } else if let attribute = attribute as? [SundeedQLiter?]{
//                            if let firstAttribute = attribute.compactMap({$0}).first {
//                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
//                                values += "\(index==0 ? "" : ",")\"SUNDEED_FOREIGN|\(firstAttribute)\""
//                                if map.hasPrimaryKey {
//                                    self.save(objects: attribute.compactMap({$0}),withForeignKey:String(describing:      map.columns[map.primaryKey] as AnyObject))
//                                } else {
//                                    throw SundeedQLiteError.PrimaryKeyError(object: object)
//                                }
//                                index += 1
//                            } else {
//                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
//                                values += "\(index==0 ? "" : ",")\"\""
//                                index += 1
//                            }
//                        } else if let attribute = attribute as? UIImage {
//                            if map.hasPrimaryKey {
//                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
//                                values += "\(index==0 ? "" : ",")\"\(attribute.dataTypeValue(forObjectID: map.columns[map.primaryKey] as! String))\""
//                                index += 1
//                            } else {
//                                throw SundeedQLiteError.PrimaryKeyError(object: object)
//                            }
//                        } else if let attribute = attribute as? Date{
//                            if map.hasPrimaryKey {
//                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
//                                values += "\(index==0 ? "" : ",")\"\(Sundeed.const.dateFormatter.string(from:attribute))\""
//                                index += 1
//                            } else {
//                                throw SundeedQLiteError.PrimaryKeyError(object: object)
//                            }
//                        } else if let attribute = attribute as? [String?]{
//                            if attribute.compactMap({$0}).count > 0 {
//                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
//                                values += "\(index==0 ? "" : ",")\"SUNDEED_PRIMITIVE_FOREIGN|\(columnName)\""
//                                if map.hasPrimaryKey {
//                                    self.saveArrayOfPrimitives(tableName: columnName, objects: attribute, withForeignKey: String(describing: map.columns[map.primaryKey] as AnyObject))
//                                } else {
//                                    throw SundeedQLiteError.PrimaryKeyError(object: object)
//                                }
//                                index += 1
//                            } else {
//                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
//                                values += "\(index==0 ? "" : ",")\"\""
//                                index += 1
//                            }
//                        } else if let attribute = attribute as? [Int?]{
//                            if attribute.compactMap({$0}).count > 0 {
//                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
//                                values += "\(index==0 ? "" : ",")\"SUNDEED_PRIMITIVE_FOREIGN|\(columnName)\""
//                                if map.hasPrimaryKey {
//                                    self.saveArrayOfPrimitives(tableName: columnName, objects: attribute, withForeignKey: String(describing:      map.columns[map.primaryKey] as AnyObject))
//                                } else {
//                                    throw SundeedQLiteError.PrimaryKeyError(object: object)
//                                }
//                                index += 1
//                            } else {
//                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
//                                values += "\(index==0 ? "" : ",")\"\""
//                                index += 1
//                            }
//                        } else if let attribute = attribute as? [Double?]{
//                            if attribute.compactMap({$0}).count > 0 {
//                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
//                                values += "\(index==0 ? "" : ",")\"SUNDEED_PRIMITIVE_FOREIGN|\(columnName)\""
//                                if map.hasPrimaryKey {
//                                    self.saveArrayOfPrimitives(tableName: columnName, objects: attribute, withForeignKey: String(describing: map.columns[map.primaryKey] as AnyObject))
//                                } else {
//                                    throw SundeedQLiteError.PrimaryKeyError(object: object)
//                                }
//                                index += 1
//                            } else {
//                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
//                                values += "\(index==0 ? "" : ",")\"\""
//                                index += 1
//                            }
//                        } else if let attribute = attribute as? [Float?]{
//                            if attribute.compactMap({$0}).count > 0 {
//                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
//                                values += "\(index==0 ? "" : ",")\"SUNDEED_PRIMITIVE_FOREIGN|\(columnName)\""
//                                if map.hasPrimaryKey {
//                                    self.saveArrayOfPrimitives(tableName: columnName, objects: attribute, withForeignKey: String(describing: map.columns[map.primaryKey] as AnyObject))
//                                } else {
//                                    throw SundeedQLiteError.PrimaryKeyError(object: object)
//                                }
//                                index += 1
//                            } else {
//                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
//                                values += "\(index==0 ? "" : ",")\"\""
//                                index += 1
//                            }
//                        } else if let attribute = attribute as? [Date?]{
//                            if attribute.compactMap({$0}).count > 0 {
//                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
//                                values += "\(index==0 ? "" : ",")\"SUNDEED_PRIMITIVE_FOREIGN|\(columnName)\""
//                                if map.hasPrimaryKey {
//                                    self.saveArrayOfPrimitives(tableName: columnName, objects: attribute, withForeignKey: String(describing: map.columns[map.primaryKey] as AnyObject))
//                                } else {
//                                    throw SundeedQLiteError.PrimaryKeyError(object: object)
//                                }
//                                index += 1
//                            } else {
//                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
//                                values += "\(index==0 ? "" : ",")\"\""
//                                index += 1
//                            }
//                        } else if let attribute = attribute as? [Bool?]{
//                            if attribute.compactMap({$0}).count > 0 {
//                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
//                                values += "\(index==0 ? "" : ",")\"SUNDEED_PRIMITIVE_FOREIGN|\(columnName)\""
//                                if map.hasPrimaryKey {
//                                    self.saveArrayOfPrimitives(tableName: columnName, objects: attribute, withForeignKey: String(describing:      map.columns[map.primaryKey] as AnyObject))
//                                } else{
//                                    throw SundeedQLiteError.PrimaryKeyError(object: object)
//                                }
//                                index += 1
//                            } else {
//                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
//                                values += "\(index==0 ? "" : ",")\"\""
//                                index += 1
//                            }
//                        } else if let attribute = attribute as? [UIImage?]{
//                            if attribute.compactMap({$0}).count > 0 {
//                                let attribute = attribute.compactMap({$0?.dataTypeValue(forObjectID: "\(String(describing: map.columns[map.primaryKey] as AnyObject))\(columnName)\(String(describing: attribute.compactMap({$0}).firstIndex(of: $0)!))")})
//                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
//                                values += "\(index==0 ? "" : ",")\"SUNDEED_PRIMITIVE_FOREIGN|\(columnName)\""
//                                if map.hasPrimaryKey {
//                                    self.saveArrayOfPrimitives(tableName: columnName, objects: attribute, withForeignKey: String(describing: map.columns[map.primaryKey] as AnyObject))
//                                } else {
//                                    throw SundeedQLiteError.PrimaryKeyError(object: object)
//                                }
//                                index += 1
//                            } else {
//                                insertStatement += "\(index==0 ? "" : ",")\(columnName)"
//                                values += "\(index==0 ? "" : ",")\"\""
//                                index += 1
//                            }
//                        } else if self.acceptDataType(forObject: attribute as AnyObject){
//                            insertStatement += "\(index==0 ? "" : ",")\(columnName)"
//                            if String(describing:attribute as AnyObject).contains("\""){
//                                values += "\(index==0 ? "" : ",")\'\(attribute as AnyObject)\'"
//                            } else{
//                                values += "\(index==0 ? "" : ",")\"\(attribute as AnyObject)\""
//                            }
//                            index += 1
//                        }
//                    }
//                    insertStatement += ") VALUES (\(values));"
//                    SundeedQLiteConnectionPool.pool.execute(query: insertStatement)
//                }
//            } catch {}
//        }
        
        
//    }
}
