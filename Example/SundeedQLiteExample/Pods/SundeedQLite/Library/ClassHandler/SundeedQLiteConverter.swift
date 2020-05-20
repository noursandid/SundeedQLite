//
//  SundeedQLiteConverter.swift
//  AppointSync
//
//  Created by Nour Sandid on 1/9/19.
//  Copyright © 2019 LUMBERCODE. All rights reserved.
//

import Foundation

public protocol SundeedQLiteConverter: class {
    func toString(value: Any?) -> String?
    func fromString(value: String) -> Any?
}
