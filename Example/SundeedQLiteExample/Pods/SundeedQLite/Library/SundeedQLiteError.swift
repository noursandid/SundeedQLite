//
//  SundeedError.swift
//  SQLiteLibrary
//
//  Created by Nour Sandid on 12/15/18.
//  Copyright © 2018 LUMBERCODE. All rights reserved.
//

import UIKit

enum SundeedQLiteError:Error,CustomStringConvertible{
    case PrimaryKeyError(object:SundeedQLiter)
    case UnsupportedType(object:SundeedQLiter?,attribute:String?)
    case NoColumnWithThisName(object:SundeedQLiter,columnName:String)
    case CantUseNameIndex(object:SundeedQLiter)
    case NoChangesMade(object:SundeedQLiter)
    case ErrorInConnection
    public var description: String {
        switch self {
        case .PrimaryKeyError(let object):
            return "SundeedQLiteError with class \(object.getTableName()): \n No Primary Key \n - To add a primary key add a '+' sign in the mapping function in the class after the designated primary map \n  e.g: self.id = map[\"ID\"]+"
        case .UnsupportedType(let object,let attribute):
            return "SundeedQLiteError with class \(object?.getTableName() ?? ""): \n Unsupported Type \(attribute ?? "") \n - Try to change the type of this attribute, or send us a suggestion so we can add it"
        case .NoColumnWithThisName(let object,let columnName):
            return "SundeedQLiteError with class \(object.getTableName()): \n No Column With Title \(columnName) \n - Try to change the column name and try again"
        case .NoChangesMade(let object):
            return "SundeedQLiteError with class \(object.getTableName()): \n Trying to perform global update statement with no changes \n - Try to add some changes and try again"
        case .CantUseNameIndex(let object):
            return "SundeedQLiteError with class \(object.getTableName()): \n Unsupported column name \"index\" because it is reserved \n - Try to change it and try again"
        case .ErrorInConnection:
            return "SundeedQLiteError with Connection : \n Unable to create a connection to the local database \n Make sure that you have access and permissions to device's files"
        }
    }
}
