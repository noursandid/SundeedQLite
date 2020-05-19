//
//  ArrayMandatoryClasses.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 5/19/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation
@testable import SundeedQLiteLibrary

class ClassContainingAMandatoryOptionalArrayWithNil: SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <**> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryArrayWithNil: SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass] = []
    required init() {}

    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <**> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryOptionalArrayWithOptionalNil: SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <**> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryArrayWithOptionalNil: SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass?] = []
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <**> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryArrayWithEmpty: SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass] = []
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <**> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryOptionalArrayWithOptionalEmpty: SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <**> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryArrayWithOptionalEmpty: SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass?] = []
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <**> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryOptionalArrayWithEmpty: SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <**> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryArrayWithData: SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass] = []
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <**> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryOptionalArrayWithData: SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <**> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryOptionalArrayWithOptionalData: SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <**> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryArrayWithOptionalData: SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass?] = []
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <**> map["mandatoryClasses"]
    }
}
