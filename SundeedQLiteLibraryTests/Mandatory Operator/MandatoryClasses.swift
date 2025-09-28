//
//  MandatoryClasses.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 5/19/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import UIKit
@testable import SundeedQLiteLibrary

class ClassWithMandatoryOptionalString: @unchecked Sendable, SundeedQLiter {
    var id: String = "qwe1"
    var mandatory: String?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalInt: @unchecked Sendable, SundeedQLiter {
    var id: String = "qwe2"
    var mandatory: Int?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalDate: @unchecked Sendable, SundeedQLiter {
    var id: String = "qwe3"
    var mandatory: Date?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalImage: @unchecked Sendable, SundeedQLiter {
    var id: String = "qwe4"
    var mandatory: UIImage?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalDouble: @unchecked Sendable, SundeedQLiter {
    var id: String = "qwe5"
    var mandatory: Double?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalFloat: @unchecked Sendable, SundeedQLiter {
    var id: String = "qwe6"
    var mandatory: Float?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfFloats: @unchecked Sendable, SundeedQLiter {
    var id: String = "qwe7"
    var mandatory: [Float]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfOptionalFloats: @unchecked Sendable, SundeedQLiter {
    var id: String = "qwe8"
    var mandatory: [Float?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfOptionalDoubles: @unchecked Sendable, SundeedQLiter {
    var id: String = "qwe9"
    var mandatory: [Double?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfDoubles: @unchecked Sendable, SundeedQLiter {
    var id: String = "qwe10"
    var mandatory: [Double]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfOptionalInts: @unchecked Sendable, SundeedQLiter {
    var id: String = "qwe11"
    var mandatory: [Int?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfInts: @unchecked Sendable, SundeedQLiter {
    var id: String = "qwe12"
    var mandatory: [Int]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}



class ClassWithMandatoryOptionalArrayOfImages: @unchecked Sendable, SundeedQLiter {
    var id: String = "qwe13"
    var mandatory: [UIImage]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfOptionalImages: @unchecked Sendable, SundeedQLiter {
    var id: String = "qwe14"
    var mandatory: [UIImage?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfStrings: @unchecked Sendable, SundeedQLiter {
    var id: String = "qwe15"
    var mandatory: [String]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfOptionalStrings: @unchecked Sendable, SundeedQLiter {
    var id: String = "qwe16"
    var mandatory: [String?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalObjects: @unchecked Sendable, SundeedQLiter {
    var id: String = "qwe17"
    var mandatory: MandatoryClass?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfObjects: @unchecked Sendable, SundeedQLiter {
    var id: String = "qwe18"
    var mandatory: [MandatoryClass]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfOptionalObjects: @unchecked Sendable, SundeedQLiter {
    var id: String = "qwe19"
    var mandatory: [MandatoryClass?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}
