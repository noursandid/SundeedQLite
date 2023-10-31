//
//  SundeedObjectWrapper.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/11/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation

typealias SundeedObject = [String: Any]

class ObjectWrapper {
    private(set) var tableName: String
    private(set) var className: String?
    var objects: SundeedObject?
    var isOrdered: Bool
    var orderBy: String
    var asc: Bool
    var hasPrimaryKey: Bool
    init(tableName: String,
         className: String?,
         objects: SundeedObject?,
         isOrdered: Bool = false,
         orderBy: String = "",
         asc: Bool = false,
         hasPrimaryKey: Bool = false) {
        self.tableName = tableName
        self.objects = objects
        self.className = className
        self.isOrdered = isOrdered
        self.orderBy = orderBy
        self.asc = asc
        self.hasPrimaryKey = hasPrimaryKey
    }
}
