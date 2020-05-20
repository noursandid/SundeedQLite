//
//  SundeedQLiteMap+Ordering.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/16/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation

postfix operator <<
public postfix func << (left: SundeedQLiteMap) -> SundeedQLiteMap {
    assert(!left.isOrdered, "You can only order by one column")
    guard let key = left.key else {
        fatalError("You can only order by one column")
    }
    left.orderBy = key
    left.asc = true
    left.isOrdered = true
    return left
}

postfix operator >>
public postfix func >> (left: SundeedQLiteMap) -> SundeedQLiteMap {
    assert(!left.isOrdered, "You can only order by one column")
    guard let key = left.key else {
        fatalError("You can only order by one column")
    }
    left.orderBy = key
    left.asc = false
    left.isOrdered = true
    return left
}
