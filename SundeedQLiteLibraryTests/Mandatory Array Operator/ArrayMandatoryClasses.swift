//
//  ArrayMandatoryClasses.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 5/19/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation
@testable import SundeedQLiteLibrary

class ClassContainingAMandatoryOptionalArrayWithNil: @unchecked Sendable, SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <**> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryArrayWithNil: @unchecked Sendable, SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass] = []
    required init() {}

    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <**> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryOptionalArrayWithOptionalNil: @unchecked Sendable, SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <**> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryArrayWithOptionalNil: @unchecked Sendable, SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass?] = []
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <**> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryArrayWithEmpty: @unchecked Sendable, SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass] = []
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <**> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryOptionalArrayWithOptionalEmpty: @unchecked Sendable, SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <**> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryArrayWithOptionalEmpty: @unchecked Sendable, SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass?] = []
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <**> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryOptionalArrayWithEmpty: @unchecked Sendable, SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <**> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryArrayWithData: @unchecked Sendable, SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass] = []
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <**> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryOptionalArrayWithData: @unchecked Sendable, SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <**> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryOptionalArrayWithOptionalData: @unchecked Sendable, SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <**> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryArrayWithOptionalData: @unchecked Sendable, SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass?] = []
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <**> map["mandatoryClasses"]
    }
}
