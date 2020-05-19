//
//  MandatoryClasses.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 5/19/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import UIKit
@testable import SundeedQLiteLibrary

class ClassWithMandatoryOptionalString: SundeedQLiter {
    var id: String = "qwe"
    var mandatory: String?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalInt: SundeedQLiter {
    var id: String = "qwe"
    var mandatory: Int?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalDate: SundeedQLiter {
    var id: String = "qwe"
    var mandatory: Date?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalImage: SundeedQLiter {
    var id: String = "qwe"
    var mandatory: UIImage?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalDouble: SundeedQLiter {
    var id: String = "qwe"
    var mandatory: Double?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalFloat: SundeedQLiter {
    var id: String = "qwe"
    var mandatory: Float?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfFloats: SundeedQLiter {
    var id: String = "qwe"
    var mandatory: [Float]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfOptionalFloats: SundeedQLiter {
    var id: String = "qwe"
    var mandatory: [Float?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfOptionalDoubles: SundeedQLiter {
    var id: String = "qwe"
    var mandatory: [Double?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfDoubles: SundeedQLiter {
    var id: String = "qwe"
    var mandatory: [Double]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfOptionalInts: SundeedQLiter {
    var id: String = "qwe"
    var mandatory: [Int?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfInts: SundeedQLiter {
    var id: String = "qwe"
    var mandatory: [Int]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}



class ClassWithMandatoryOptionalArrayOfImages: SundeedQLiter {
    var id: String = "qwe"
    var mandatory: [UIImage]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfOptionalImages: SundeedQLiter {
    var id: String = "qwe"
    var mandatory: [UIImage?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfStrings: SundeedQLiter {
    var id: String = "qwe"
    var mandatory: [String]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfOptionalStrings: SundeedQLiter {
    var id: String = "qwe"
    var mandatory: [String?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalObjects: SundeedQLiter {
    var id: String = "qwe"
    var mandatory: MandatoryClass?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfObjects: SundeedQLiter {
    var id: String = "qwe"
    var mandatory: [MandatoryClass]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfOptionalObjects: SundeedQLiter {
    var id: String = "qwe"
    var mandatory: [MandatoryClass?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}
