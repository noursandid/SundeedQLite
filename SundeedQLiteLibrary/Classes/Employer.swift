//
//  Employer.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 10/5/19.
//  Copyright © 2019 LUMBERCODE. All rights reserved.
//

import Foundation

class Employer: SundeedQLiter {
    var id: String!
    var fullName: String?
    var employees: [Employee]?
    
    required init() {}
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        fullName <~> map["fullName"]<<
        employees <~> map["employees"]
    }
}
