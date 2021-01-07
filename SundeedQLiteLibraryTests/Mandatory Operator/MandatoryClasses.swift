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
    var id: String = "qwe1"
    var mandatory: String?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalInt: SundeedQLiter {
    var id: String = "qwe2"
    var mandatory: Int?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalDate: SundeedQLiter {
    var id: String = "qwe3"
    var mandatory: Date?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalImage: SundeedQLiter {
    var id: String = "qwe4"
    var mandatory: UIImage?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalDouble: SundeedQLiter {
    var id: String = "qwe5"
    var mandatory: Double?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalFloat: SundeedQLiter {
    var id: String = "qwe6"
    var mandatory: Float?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfFloats: SundeedQLiter {
    var id: String = "qwe7"
    var mandatory: [Float]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfOptionalFloats: SundeedQLiter {
    var id: String = "qwe8"
    var mandatory: [Float?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfOptionalDoubles: SundeedQLiter {
    var id: String = "qwe9"
    var mandatory: [Double?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfDoubles: SundeedQLiter {
    var id: String = "qwe10"
    var mandatory: [Double]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfOptionalInts: SundeedQLiter {
    var id: String = "qwe11"
    var mandatory: [Int?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfInts: SundeedQLiter {
    var id: String = "qwe12"
    var mandatory: [Int]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}



class ClassWithMandatoryOptionalArrayOfImages: SundeedQLiter {
    var id: String = "qwe13"
    var mandatory: [UIImage]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfOptionalImages: SundeedQLiter {
    var id: String = "qwe14"
    var mandatory: [UIImage?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfStrings: SundeedQLiter {
    var id: String = "qwe15"
    var mandatory: [String]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfOptionalStrings: SundeedQLiter {
    var id: String = "qwe16"
    var mandatory: [String?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalObjects: SundeedQLiter {
    var id: String = "qwe17"
    var mandatory: MandatoryClass?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfObjects: SundeedQLiter {
    var id: String = "qwe18"
    var mandatory: [MandatoryClass]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}

class ClassWithMandatoryOptionalArrayOfOptionalObjects: SundeedQLiter {
    var id: String = "qwe19"
    var mandatory: [MandatoryClass?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatory <*> map["mandatory"]
    }
}
