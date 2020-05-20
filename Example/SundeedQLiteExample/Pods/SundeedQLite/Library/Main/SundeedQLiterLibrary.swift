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
public func == (left: SundeedColumn, right: String) -> SundeedExpression<Bool>? {
return SundeedExpression(left.value, right)
}
infix operator <~
/** Setting variables in global update statement in local database */
public func <~ (left: SundeedColumn, right: String) -> SundeedUpdateSetStatement {
    return SundeedUpdateSetStatement(sundeedColumn: left, withValue: right as AnyObject)
}
public class SundeedColumn {
    var value: String = ""
    required public init(_ value: String) {
        self.value = value
    }
    public typealias StringLiteralType = String
}
/** SundeedColumn("columnName") == "value" */
public struct SundeedExpression<Bool> {
    public var template: String
    public var bindings: String
    public init(_ template: String, _ bindings: String) {
        self.template = template
        self.bindings = bindings
    }
    public func toQuery() -> String {
        return "\(self.template) = \"\(self.bindings)\""
    }
}
/** SundeedColumn("columnName") <~ "value" */
public struct SundeedUpdateSetStatement {
    public var column: SundeedColumn
    public var value: AnyObject
    public init(sundeedColumn column: SundeedColumn, withValue value: AnyObject) {
        self.column = column
        self.value = value
    }
}

extension UIImage {
    static func fromDatatypeValue(filePath: String) -> UIImage? {
        if let documentsDirectoryURL = FileManager
            .default.urls(for: .documentDirectory,
                          in: .userDomainMask)
            .first {
            let fileURL = documentsDirectoryURL.appendingPathComponent(filePath)
            if FileManager.default.fileExists(atPath: fileURL.path),
                let data = try? Data(contentsOf: fileURL) {
                return  UIImage(data: data)
            }
        }
        return nil
    }
    func dataTypeValue(forObjectID objectID: String) -> String {
        guard let documentsDirectoryURL = FileManager
            .default.urls(for: .documentDirectory,
                          in: .userDomainMask)
            .first else { fatalError() }
        let fileURL = documentsDirectoryURL.appendingPathComponent("\(objectID).png")
        try? self.pngData()?.write(to: fileURL)
        return fileURL.lastPathComponent
    }
}
