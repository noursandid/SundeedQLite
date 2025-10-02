//
//  SundeedLog.swift
//  SundeedQLite
//
//  Created by Nour Sandid on 27/09/2025.
//

public enum SundeedLogLevel: Int {
    case verbose = 0
    case info = 1
    case error = 2
    case production = 3
}

class SundeedLogger {
    static var logLevel: SundeedLogLevel = .production
    static var testingDidPrint: Bool = false
    static func debug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        if logLevel.rawValue <= SundeedLogLevel.verbose.rawValue {
            testingDidPrint = true
            print(["SundeedQLiteDebug"] + items, separator: separator, terminator: terminator)
        }
    }
    static func info(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        if logLevel.rawValue <= SundeedLogLevel.info.rawValue {
            testingDidPrint = true
            print(["SundeedQLiteInfo"] + items, separator: separator, terminator: terminator)
        }
    }
    static func error(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        if logLevel.rawValue <= SundeedLogLevel.error.rawValue {
            testingDidPrint = true
            print(["SundeedQLiteError"] + items, separator: separator, terminator: terminator)
        }
    }
}
