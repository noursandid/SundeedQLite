//
//  Statement.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/10/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation

class Statement {
    final func addSeparatorIfNeeded(separator: String,
                                    forStatement statement: inout String,
                                    needed: Bool) {
        statement.append(needed ? separator : "")
    }
    final func getQuotation(forValue value: String) -> String {
        let characterSet = CharacterSet(charactersIn: "\'")
        return value.rangeOfCharacter(from: characterSet) != nil ? "\"" : "\'"
    }
    final func isLastIndex<T>(index: Int, in array: [T]) -> Bool {
        index != array.count - 1
    }
}
