//
//  SundeedQLiteMap.swift
//  SQLiteLibrary
//
//  Created by Nour Sandid on 12/9/18.
//  Copyright © 2018 LUMBERCODE. All rights reserved.
//

import Foundation

public class SundeedQLiteMap {
    var map: [String: Any] = [:]
    var columns: [String: AnyObject] = [:]
    var types: [String: ParameterType] = [:]
    var fetchingColumns: Bool = false
    var key: String?
    var currentValue: Any?
    private static let referencesQueue = DispatchQueue(label: "com.sundeed.references", attributes: .concurrent)
    private static var _references: [String: [String: SundeedQLiter]] = [:]
    static var references: [String: [String: SundeedQLiter]] {
        get { referencesQueue.sync { _references } }
        set { referencesQueue.sync(flags: .barrier) { _references = newValue } }
    }
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
    func addColumn<T>(attribute: T, withColumnName columnName: String, type: ParameterType) {
        self.columns[columnName] = attribute as AnyObject
        self.types[columnName] = type
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
        referencesQueue.sync(flags: .barrier) {
            if _references[className] == nil {
                _references[className] = [:]
            }
            if _references[className]?["\(value)"] == nil {
                _references[className]?["\(value)"] = object
            }
        }
    }
    static func getReference(andValue value: AnyObject,
                             andClassName name: String) -> SundeedQLiter? {
        referencesQueue.sync {
            return _references[name]?["\(value)"]
        }
    }
    static func removeReference(value: AnyObject,
                                andClassName className: String) {
        referencesQueue.sync(flags: .barrier) {
            _references[className]?["\(value)"] = nil
        }
    }
    public static func clearReferences() {
        referencesQueue.sync(flags: .barrier) {
            _references.removeAll()
        }
    }
}
