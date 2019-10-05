//
//  SundeedQLiterLibrary.swift
//  SQLiteLibrary
//
//  Created by Nour Sandid on 12/9/18.
//  Copyright © 2018 LUMBERCODE. All rights reserved.
//

import UIKit
import SQLite3

/** Filter in local database */
public func == (left: SundeedColumn, right: String)->SundeedExpression<Bool>? {
return SundeedExpression(left.value, right)
}
infix operator <~
/** Setting variables in global update statement in local database */
public func <~ (left: SundeedColumn, right: String)->SundeedUpdateSetStatement {
    return SundeedUpdateSetStatement(sundeedColumn: left, withValue: right as AnyObject)
}
public class SundeedColumn{
    var value:String = ""
    required public init(_ value:String) {
        self.value = value
    }
    public typealias StringLiteralType = String
}
/** SundeedColumn("columnName") == "value" */
public struct SundeedExpression<Bool>{
    public var template: String
    public var bindings: String
    
    public init(_ template: String, _ bindings: String) {
        self.template = template
        self.bindings = bindings
    }
    public func toWhereStatement()->String{
        return "WHERE \(self.template) = \"\(self.bindings)\""
    }
    public func toQuery()->String{
        return "\(self.template) = \"\(self.bindings)\""
    }
}
/** SundeedColumn("columnName") <~ "value" */
public struct SundeedUpdateSetStatement{
    public var column: SundeedColumn
    public var value: AnyObject
    
    public init(sundeedColumn column: SundeedColumn, withValue value:AnyObject) {
        self.column = column
        self.value = value
    }
}

