//
//  SundeedQLiteMap.swift
//  SQLiteLibrary
//
//  Created by Nour Sandid on 12/9/18.
//  Copyright © 2018 LUMBERCODE. All rights reserved.
//

import UIKit

public class SundeedQLiteMap {
    var map: [String: Any] = [:]
    var columns: [String: AnyObject] = [:]
    var fetchingColumns: Bool = false
    var key: String?
    var currentValue: Any?
    static var references: [String: [String: SundeedQLiter]] = [:]
    var primaryKey: String = ""
    var orderBy: String = ""
    var asc: Bool = true
    var isOrdered: Bool = false
    var hasPrimaryKey: Bool = false
    var isSafeToAdd: Bool = true
    public subscript(key: String) -> SundeedQLiteMap {
        self.key = key
        if map.contains(where: { (key1, _) -> Bool in
            return key1 == key
        }) {
            self.currentValue = map[key]
        } else {
            self.currentValue = nil
        }
        return self
    }
    func addColumn<T>(attribute: T, withColumnName columnName: String) {
        self.columns[columnName] = attribute as AnyObject
        if hasPrimaryKey && columnName == primaryKey {
            self.columns[Sundeed.shared.primaryKey] = attribute as AnyObject
        }
    }
    init(fetchingColumns: Bool) {
        self.fetchingColumns = fetchingColumns
    }
    init(dictionnary: [String: Any]) {
        self.map = dictionnary
        self.fetchingColumns = false
    }
    static func addReference(object: SundeedQLiter,
                             andValue value: AnyObject,
                             andClassName className: String) {
        if SundeedQLiteMap.references[className] == nil {
            SundeedQLiteMap.references[className] = [:]
        }
        if SundeedQLiteMap.references[className]?["\(value)"] == nil {
            SundeedQLiteMap.references[className]?["\(value)"] = object
        }
    }
    static func getReference(andValue value: AnyObject,
                             andClassName name: String) -> SundeedQLiter? {
        if SundeedQLiteMap.references[name] == nil {
            SundeedQLiteMap.references[name] = [:]
        }
        return SundeedQLiteMap.references[name]?["\(value)"]
    }
    static func removeReference(value: AnyObject,
                                andClassName className: String) {
        SundeedQLiteMap.references[className]?["\(value)"] = nil
    }
}
