//
//  SundeedQLiteMap+Primary.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/16/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation

postfix operator +
public postfix func + (left: SundeedQLiteMap) -> SundeedQLiteMap {
    assert(!left.hasPrimaryKey, "You can only have one primary key")
    guard let key = left.key else {
        fatalError("You can only have one primary key")
    }
    left.primaryKey = key
    left.hasPrimaryKey = true
    return left
}
