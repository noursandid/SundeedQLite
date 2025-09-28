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
public func == (left: SundeedColumn, right: String) -> SundeedExpression<Bool> {
return SundeedExpression(left.value, right)
}
infix operator <~
/** Setting variables in global update statement in local database */
public func <~ (left: SundeedColumn, right: String) -> SundeedUpdateSetStatement {
    return SundeedUpdateSetStatement(sundeedColumn: left, withValue: right as AnyObject)
}
final public class SundeedColumn: Sendable {
    let value: String
    required public init(_ value: String) {
        self.value = value
    }
    public typealias StringLiteralType = String
}
/** SundeedColumn("columnName") == "value" */
public struct SundeedExpression<Bool>: Sendable {
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
            let fileURL = documentsDirectoryURL.appendingPathComponent("SundeedQLite/Image", isDirectory: true).appendingPathComponent(filePath)
            do {
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    return try autoreleasepool {
                        let data = try Data(contentsOf: fileURL)
                        SundeedLogger.debug("SundeedQLite: Fetching image from \(fileURL.absoluteString)")
                        return  UIImage(data: data)
                    }
                }
            } catch {
                SundeedLogger.error(error)
            }
        }
        return nil
    }
    func dataTypeValue(forObjectID objectID: String) -> String {
        guard let documentsDirectoryURL = FileManager
            .default.urls(for: .documentDirectory, in: .userDomainMask)
            .first else {
            fatalError("Unable to access document directory")
        }
        
        let directoryURL = documentsDirectoryURL.appendingPathComponent("SundeedQLite/Image", isDirectory: true)
        let fileURL = directoryURL.appendingPathComponent("\(objectID).png")
        
        do {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            SundeedLogger.debug("Saving image to \(fileURL.absoluteString)")
            try self.pngData()?.write(to: fileURL, options: .completeFileProtectionUnlessOpen)
            SundeedLogger.debug("Image Saved to \(fileURL.absoluteString)")
        } catch {
            SundeedLogger.error(error)
            SundeedLogger.debug("Error saving PNG: \(error) \(#file) \(#line)")
        }
        
        return fileURL.lastPathComponent
    }
}
