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
    final func getQuotation(forValue value: Any) -> String {
        let characterSet = CharacterSet(charactersIn: "\'")
        if let value = value as? String {
            return value.rangeOfCharacter(from: characterSet) != nil ? "\"" : "\'"
        } else if let _ = value as? Date {
            return ""
        } else if let _ = value as? Int {
            return ""
        } else if let _ = value as? Double {
            return ""
        } else if let _ = value as? Float {
            return ""
        } else {
            return "\""
        }
    }
    final func isLastIndex<T>(index: Int, in array: [T]) -> Bool {
        index != array.count - 1
    }
}
