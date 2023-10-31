//
//  NoPrimariesClasses.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 5/19/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import XCTest
@testable import SundeedQLiteLibrary

class ClassWithNoPrimaryWithImage: SundeedQLiter {
    var image: UIImage?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        image <~> map["image"]
    }
    
    func fillData() {
        image = UIImage(named: "image")
    }
}

class ClassWithNoPrimaryWithImageArray: SundeedQLiter {
    var images: [UIImage?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        images <~> map["images"]
    }
    
    func fillData() {
        images = [UIImage(named: "image")]
    }
}

class ClassWithNoPrimaryWithPrimitiveArray: SundeedQLiter {
    var strings: [String]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        strings <~> map["strings"]
    }
    
    func fillData() {
        strings = ["test"]
    }
}

class ClassWithNoPrimaryWithDate: SundeedQLiter {
    var date: Date?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        date <~> map["date"]
    }
    
    func fillData() {
        date = Date()
    }
}


class ClassWithNoPrimaryWithSubClass: SundeedQLiter {
    var object: EmployeeForTesting?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        object <~> map["object"]
    }
    
    func fillData() {
        object = EmployeeForTesting(id: "TestID")
    }
    
}

class ClassWithNoPrimaryWithSubClassArray: SundeedQLiter {
    var objects: [EmployeeForTesting?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        objects <~> map["objects"]
    }
    
    func fillData() {
        objects = [EmployeeForTesting(id: "TestID")]
    }
    
}


class ClassWithNoPrimary: SundeedQLiter {
    var firstName: String?
    var lastName: String?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        firstName <~> map["firstName"]
        lastName <~> map["lastName"]
    }
    
    func fillData() {
        firstName = "TestFirst"
        lastName = "TestLast"
    }
    
}
