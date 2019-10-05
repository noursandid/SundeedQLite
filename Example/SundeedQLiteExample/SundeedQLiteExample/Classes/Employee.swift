//
//  Employee.swift
//  SundeedQLiteExample
//
//  Created by Nour Sandid on 10/5/19.
//  Copyright © 2019 LUMBERCODE. All rights reserved.
//

import Foundation
import SundeedQLite

class Employee: SundeedQLiter {
    var a: String?
    required init() {}
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
     a <~> map[""]
    }
    
    
}
