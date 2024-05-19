//
//  EmployerForTesting.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 10/8/19.
//  Copyright © 2019 LUMBERCODE. All rights reserved.
//

import XCTest
@testable import SundeedQLiteLibrary

class EmployeeForTesting: SundeedQLiter {
    var id: String!
    var firstName: String?
    required init() {}
    init(id: String) {
        self.id = id
    }
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        firstName <~> map["firstName"]
    }
}

class TypeConverter: SundeedQLiteConverter {
    func fromString(value: String) -> Any? {
        return Type.fromString(string: value)
    }
    func toString(value: Any?) -> String? {
        return (value as? Type)?.stringValue()
    }
}

enum Type {
    case manager
    case ceo
    
    static func fromString(string: String) -> Self? {
        switch string {
        case "manager":
            return .manager
        case "ceo":
            return .ceo
        default:
            return nil
        }
    }
    
    func stringValue() -> String? {
        switch self {
        case .ceo:
            return "ceo"
        case .manager:
            return "manager"
        }
    }
}

class EmployerForTesting: SundeedQLiter {
    var type: Type?
    var mandatoryType: Type = .manager
    var data: Data?
    var mandatoryData: Data = "Test Data".data(using: .utf8) ?? Data()
    var optionalData: Data?
    var arrayOfTypes: [Type] = []
    var optionalArrayOfTypes: [Type]?
    var optionalArrayOfOptionalTypes: [Type?]?
    var arrayOfOptionalTypes: [Type?] = []
    var string: String = ""
    var optionalString: String?
    var object: EmployeeForTesting = EmployeeForTesting(id: "EFGH-9012-IJKL-3456")
    var optionalObject: EmployeeForTesting?
    var integer: Int = 0
    var optionalInteger: Int?
    var double: Double = 0
    var optionalDouble: Double?
    var float: Float = 0
    var optionalFloat: Float?
    var bool: Bool = true
    var optionalBool: Bool?
    var date: Date = Date()
    var optionalDate: Date?
    var image: UIImage = UIImage(named: "image")!
    var optionalImage: UIImage?
    var arrayOfStrings: [String] = []
    var arrayOfOptionalStrings: [String?] = []
    var optionalArrayOfStrings: [String]?
    var optionalArrayOfOptionalStrings: [String?]?
    var arrayOfData: [Data] = []
    var arrayOfOptionalData: [Data?] = []
    var optionalArrayOfData: [Data]?
    var optionalArrayOfOptionalData: [Data?]?
    var arrayOfObjects: [EmployeeForTesting] = []
    var arrayOfOptionalObjects: [EmployeeForTesting?] = []
    var optionalArrayOfObjects: [EmployeeForTesting]?
    var optionalArrayOfOptionalObjects: [EmployeeForTesting?]?
    var arrayOfIntegers: [Int] = []
    var arrayOfOptionalIntegers: [Int?] = []
    var optionalArrayOfIntegers: [Int]?
    var optionalArrayOfOptionalIntegers: [Int?]?
    var arrayOfDoubles: [Double] = []
    var arrayOfOptionalDoubles: [Double?] = []
    var optionalArrayOfDoubles: [Double]?
    var optionalArrayOfOptionalDoubles: [Double?]?
    var arrayOfFloats: [Float] = []
    var arrayOfOptionalFloats: [Float?] = []
    var optionalArrayOfFloats: [Float]?
    var optionalArrayOfOptionalFloats: [Float?]?
    var arrayOfBools: [Bool] = []
    var arrayOfOptionalBools: [Bool?] = []
    var optionalArrayOfBools: [Bool]?
    var optionalArrayOfOptionalBools: [Bool?]?
    var arrayOfDates: [Date] = []
    var arrayOfOptionalDates: [Date?] = []
    var optionalArrayOfDates: [Date]?
    var optionalArrayOfOptionalDates: [Date?]?
    var arrayOfImages: [UIImage] = []
    var arrayOfOptionalImages: [UIImage?] = []
    var optionalArrayOfImages: [UIImage]?
    var optionalArrayOfOptionalImages: [UIImage?]?
    var nilString: String?
    var nilObject: EmployeeForTesting?
    var nilInteger: Int?
    var nilDouble: Double?
    var nilFloat: Float?
    var nilBool: Bool?
    var nilDate: Date?
    var nilImage: UIImage?
    var nilArrayOfStrings: [String]?
    var nilArrayOfOptionalStrings: [String]?
    var nilArrayOfObjects: [EmployeeForTesting]?
    var nilArrayOfOptionalObjects: [EmployeeForTesting?]?
    var nilArrayOfDoubles: [Double]?
    var nilArrayOfOptionalDoubles: [Double?]?
    var nilArrayOfFloats: [Float]?
    var nilArrayOfOptionalFloats: [Float?]?
    var nilArrayOfBools: [Bool]?
    var nilArrayOfOptionalBools: [Bool?]?
    var nilArrayOfDates: [Date]?
    var nilArrayOfOptionalDates: [Date?]?
    var nilArrayOfImages: [UIImage]?
    var nilArrayOfOptionalImages: [UIImage?]?
    var emptyArrayOfStrings: [String] = []
    var emptyArrayOfOptionalStrings: [String] = []
    var emptyArrayOfObjects: [EmployeeForTesting] = []
    var emptyArrayOfOptionalObjects: [EmployeeForTesting?] = []
    var emptyArrayOfDoubles: [Double] = []
    var emptyArrayOfOptionalDoubles: [Double?] = []
    var emptyArrayOfFloats: [Float] = []
    var emptyArrayOfOptionalFloats: [Float?] = []
    var emptyArrayOfBools: [Float] = []
    var emptyArrayOfOptionalBools: [Float?] = []
    var emptyArrayOfDates: [Float] = []
    var emptyArrayOfOptionalDates: [Float?] = []
    var emptyArrayOfImages: [UIImage] = []
    var emptyArrayOfOptionalImages: [UIImage?] = []
    
    required init() {}
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        type <~> (map["type"], TypeConverter())
        mandatoryType <~> (map["mandatoryType"], TypeConverter())
        data <~> map["data"]
        mandatoryData <~> map["mandatoryData"]
        optionalData <~> map["optionalData"]
        arrayOfTypes <~> (map["arrayOfTypes"], TypeConverter())
        optionalArrayOfTypes <~> (map["optionalArrayOfTypes"], TypeConverter())
        optionalArrayOfOptionalTypes <~> (map["optionalArrayOfOptionalTypes"], TypeConverter())
        arrayOfOptionalTypes <~> (map["arrayOfOptionalTypes"], TypeConverter())
        string <~> map["string"]+
        optionalString <~> map["optionalString"]
        object <~> map["object"]
        optionalObject <~> map["optionalObject"]
        integer <~> map["integer"]>>
        optionalInteger <~> map["optionalInteger"]
        double <~> map["double"]
        optionalDouble <~> map["optionalDouble"]
        float <~> map["float"]
        optionalFloat <~> map["optionalFloat"]
        bool <~> map["bool"]
        optionalBool <~> map["optionalBool"]
        date <~> map["date"]
        optionalDate <~> map["optionalDate"]
        image <~> map["image"]
        optionalImage <~> map["optionalImage"]
        arrayOfStrings <~> map["arrayOfStrings"]
        arrayOfOptionalStrings <~> map["arrayOfOptionalStrings"]
        optionalArrayOfStrings <~> map["optionalArrayOfStrings"]
        optionalArrayOfOptionalStrings <~> map["optionalArrayOfOptionalStrings"]
        arrayOfData <~> map["arrayOfData"]
        arrayOfOptionalData <~> map["arrayOfOptionalData"]
        optionalArrayOfData <~> map["optionalArrayOfData"]
        optionalArrayOfOptionalData <~> map["optionalArrayOfOptionalData"]
        arrayOfObjects <~> map["arrayOfObjects"]
        arrayOfOptionalObjects <~> map["arrayOfOptionalObjects"]
        optionalArrayOfObjects <~> map["optionalArrayOfObjects"]
        optionalArrayOfOptionalObjects <~> map["optionalArrayOfOptionalObjects"]
        arrayOfIntegers <~> map["arrayOfIntegers"]
        arrayOfOptionalIntegers <~> map["arrayOfOptionalIntegers"]
        optionalArrayOfIntegers <~> map["optionalArrayOfIntegers"]
        optionalArrayOfOptionalIntegers <~> map["optionalArrayOfOptionalIntegers"]
        arrayOfDoubles <~> map["arrayOfDoubles"]
        arrayOfOptionalDoubles <~> map["arrayOfOptionalDoubles"]
        optionalArrayOfDoubles <~> map["optionalArrayOfDoubles"]
        optionalArrayOfOptionalDoubles <~> map["optionalArrayOfOptionalDoubles"]
        arrayOfFloats <~> map["arrayOfFloats"]
        arrayOfOptionalFloats <~> map["arrayOfOptionalFloats"]
        optionalArrayOfFloats <~> map["optionalArrayOfFloats"]
        optionalArrayOfOptionalFloats <~> map["optionalArrayOfOptionalFloats"]
        arrayOfBools <~> map["arrayOfBools"]
        arrayOfOptionalBools <~> map["arrayOfOptionalBools"]
        optionalArrayOfBools <~> map["optionalArrayOfBools"]
        optionalArrayOfOptionalBools <~> map["optionalArrayOfOptionalBools"]
        arrayOfDates <~> map["arrayOfDates"]
        arrayOfOptionalDates <~> map["arrayOfOptionalDates"]
        optionalArrayOfDates <~> map["optionalArrayOfDates"]
        optionalArrayOfOptionalDates <~> map["optionalArrayOfOptionalDates"]
        arrayOfImages <~> map["arrayOfImages"]
        arrayOfOptionalImages <~> map["arrayOfOptionalImages"]
        optionalArrayOfImages <~> map["optionalArrayOfImages"]
        optionalArrayOfOptionalImages <~> map["optionalArrayOfOptionalImages"]
        nilString <~> map["nilString"]
        nilObject <~> map["nilObject"]
        nilInteger <~> map["nilInteger"]
        nilDouble <~> map["nilDouble"]
        nilFloat <~> map["nilFloat"]
        nilBool <~> map["nilBool"]
        nilDate <~> map["nilDate"]
        nilImage <~> map["nilImage"]
        nilArrayOfStrings <~> map["nilArrayOfStrings"]
        nilArrayOfOptionalStrings <~> map["nilArrayOfOptionalStrings"]
        nilArrayOfObjects <~> map["nilArrayOfObjects"]
        nilArrayOfOptionalObjects <~> map["nilArrayOfOptionalObjects"]
        nilArrayOfDoubles <~> map["nilArrayOfDoubles"]
        nilArrayOfOptionalDoubles <~> map["nilArrayOfOptionalDoubles"]
        nilArrayOfFloats <~> map["nilArrayOfFloats"]
        nilArrayOfOptionalFloats <~> map["nilArrayOfOptionalFloats"]
        nilArrayOfBools <~> map["nilArrayOfBools"]
        nilArrayOfOptionalBools <~> map["nilArrayOfOptionalBools"]
        nilArrayOfDates <~> map["nilArrayOfDates"]
        nilArrayOfOptionalDates <~> map["nilArrayOfOptionalDates"]
        nilArrayOfImages <~> map["nilArrayOfImages"]
        nilArrayOfOptionalImages <~> map["nilArrayOfOptionalImages"]
        emptyArrayOfStrings <~> map["emptyArrayOfStrings"]
        emptyArrayOfOptionalStrings <~> map["emptyArrayOfOptionalStrings"]
        emptyArrayOfObjects <~> map["emptyArrayOfObjects"]
        emptyArrayOfOptionalObjects <~> map["emptyArrayOfOptionalObjects"]
        emptyArrayOfDoubles <~> map["emptyArrayOfDoubles"]
        emptyArrayOfOptionalDoubles <~> map["emptyArrayOfOptionalDoubles"]
        emptyArrayOfFloats <~> map["emptyArrayOfFloats"]
        emptyArrayOfOptionalFloats <~> map["emptyArrayOfOptionalFloats"]
        emptyArrayOfBools <~> map["emptyArrayOfBools"]
        emptyArrayOfOptionalBools <~> map["emptyArrayOfOptionalBools"]
        emptyArrayOfDates <~> map["emptyArrayOfDates"]
        emptyArrayOfOptionalDates <~> map["emptyArrayOfOptionalDates"]
        emptyArrayOfImages <~> map["emptyArrayOfImages"]
        emptyArrayOfOptionalImages <~> map["emptyArrayOfOptionalImages"]
    }
    
    
    func fillData() {
        var employees: [EmployeeForTesting] = []
        
        for i in 0...5 {
            let employee = EmployeeForTesting()
            employee.id = "EMP\(i)"
            employee.firstName = "Nour\(i)"
            employees.append(employee)
        }
        type = .manager
        mandatoryType = .ceo
        data = "Testing Data".data(using: .utf8)
        mandatoryData = "Testing Mandatory Data".data(using: .utf8) ?? Data()
        optionalData = "Testing Optional Data".data(using: .utf8)
        arrayOfTypes = [.manager, .ceo]
        optionalArrayOfTypes = [.manager, .ceo]
        optionalArrayOfOptionalTypes = [.manager, .ceo]
        arrayOfOptionalTypes = [.manager, .ceo]
        string = "string"
        optionalString = "optionalString"
        object = employees[0]
        optionalObject = employees[1]
        integer = 1
        optionalInteger = 2
        double = 3
        optionalDouble = 4
        float = 5
        optionalFloat = 6
        bool = true
        optionalBool = true
        date = Date()
        optionalDate = Date()
        image = UIImage(named: "1")!
        optionalImage = UIImage(named: "2")
        arrayOfStrings = ["string1", "string2"]
        arrayOfOptionalStrings = ["string3", nil]
        optionalArrayOfStrings = ["string4", "string6"]
        optionalArrayOfOptionalStrings = ["string7", nil]
        arrayOfData = ["Testing Array Of Data".data(using: .utf8)!]
        arrayOfOptionalData = ["Testing Array Of Optional Data".data(using: .utf8), nil]
        optionalArrayOfData = ["Testing Optional Array Of Data".data(using: .utf8)!]
        optionalArrayOfOptionalData = ["Testing Optional Array Of Optional Data".data(using: .utf8), nil]
        arrayOfObjects = [employees[2]]
        arrayOfOptionalObjects = [employees[3], nil]
        optionalArrayOfObjects = [employees[4]]
        optionalArrayOfOptionalObjects = [employees[5], nil]
        arrayOfIntegers = [1, 2]
        arrayOfOptionalIntegers = [2, nil]
        optionalArrayOfIntegers = [1, 2]
        optionalArrayOfOptionalIntegers = [2, nil]
        arrayOfDoubles = [3, 4]
        arrayOfOptionalDoubles = [4, nil]
        optionalArrayOfDoubles = [3, 4]
        optionalArrayOfOptionalDoubles = [4, nil]
        arrayOfFloats = [5, 6]
        arrayOfOptionalFloats = [6, nil]
        optionalArrayOfFloats = [5, 6]
        optionalArrayOfOptionalFloats = [6, nil]
        arrayOfBools = [true, false]
        arrayOfOptionalBools = [true, nil]
        optionalArrayOfBools = [true, false]
        optionalArrayOfOptionalBools = [true, nil]
        arrayOfDates = [Date(), Date()]
        arrayOfOptionalDates = [Date(), nil]
        optionalArrayOfDates = [Date(), Date()]
        optionalArrayOfOptionalDates = [Date(), nil]
        arrayOfImages = [UIImage(named: "3")!, UIImage(named: "4")!]
        arrayOfOptionalImages = [UIImage(named: "5"), nil]
        optionalArrayOfImages = [UIImage(named: "1")!, UIImage(named: "2")!]
        optionalArrayOfOptionalImages = [UIImage(named: "3"), nil]
    }
    
    func printEmployer() {
        let mirror = Mirror(reflecting: self)
        for (_, value) in mirror.children.enumerated() {
            print("\(value.label ?? "\"\""): \(String(describing: value.value))")
        }
    }
}

class EmployerWithNoPrimaryForTesting: SundeedQLiter {
    var type: Type?
    var data: Data?
    var mandatoryData: Data = "Test Data".data(using: .utf8) ?? Data()
    var optionalData: Data?
    var string: String = ""
    var optionalString: String?
    var object: EmployeeForTesting = EmployeeForTesting(id: "EFGH-9012-IJKL-3456")
    var optionalObject: EmployeeForTesting?
    var integer: Int = 0
    var optionalInteger: Int?
    var double: Double = 0
    var optionalDouble: Double?
    var float: Float = 0
    var optionalFloat: Float?
    var bool: Bool = true
    var optionalBool: Bool?
    var date: Date = Date()
    var optionalDate: Date?
    var image: UIImage = UIImage(named: "image")!
    var optionalImage: UIImage?
    var arrayOfStrings: [String] = []
    var arrayOfOptionalStrings: [String?] = []
    var optionalArrayOfStrings: [String]?
    var optionalArrayOfOptionalStrings: [String?]?
    var arrayOfData: [Data] = []
    var arrayOfOptionalData: [Data?] = []
    var optionalArrayOfData: [Data]?
    var optionalArrayOfOptionalData: [Data?]?
    var arrayOfObjects: [EmployeeForTesting] = []
    var arrayOfOptionalObjects: [EmployeeForTesting?] = []
    var optionalArrayOfObjects: [EmployeeForTesting]?
    var optionalArrayOfOptionalObjects: [EmployeeForTesting?]?
    var arrayOfIntegers: [Int] = []
    var arrayOfOptionalIntegers: [Int?] = []
    var optionalArrayOfIntegers: [Int]?
    var optionalArrayOfOptionalIntegers: [Int?]?
    var arrayOfDoubles: [Double] = []
    var arrayOfOptionalDoubles: [Double?] = []
    var optionalArrayOfDoubles: [Double]?
    var optionalArrayOfOptionalDoubles: [Double?]?
    var arrayOfFloats: [Float] = []
    var arrayOfOptionalFloats: [Float?] = []
    var optionalArrayOfFloats: [Float]?
    var optionalArrayOfOptionalFloats: [Float?]?
    var arrayOfBools: [Bool] = []
    var arrayOfOptionalBools: [Bool?] = []
    var optionalArrayOfBools: [Bool]?
    var optionalArrayOfOptionalBools: [Bool?]?
    var arrayOfDates: [Date] = []
    var arrayOfOptionalDates: [Date?] = []
    var optionalArrayOfDates: [Date]?
    var optionalArrayOfOptionalDates: [Date?]?
    var arrayOfImages: [UIImage] = []
    var arrayOfOptionalImages: [UIImage?] = []
    var optionalArrayOfImages: [UIImage]?
    var optionalArrayOfOptionalImages: [UIImage?]?
    var nilString: String?
    var nilObject: EmployeeForTesting?
    var nilInteger: Int?
    var nilDouble: Double?
    var nilFloat: Float?
    var nilBool: Bool?
    var nilDate: Date?
    var nilImage: UIImage?
    var nilArrayOfStrings: [String]?
    var nilArrayOfOptionalStrings: [String]?
    var nilArrayOfObjects: [EmployeeForTesting]?
    var nilArrayOfOptionalObjects: [EmployeeForTesting?]?
    var nilArrayOfDoubles: [Double]?
    var nilArrayOfOptionalDoubles: [Double?]?
    var nilArrayOfFloats: [Float]?
    var nilArrayOfOptionalFloats: [Float?]?
    var nilArrayOfBools: [Bool]?
    var nilArrayOfOptionalBools: [Bool?]?
    var nilArrayOfDates: [Date]?
    var nilArrayOfOptionalDates: [Date?]?
    var nilArrayOfImages: [UIImage]?
    var nilArrayOfOptionalImages: [UIImage?]?
    var emptyArrayOfStrings: [String] = []
    var emptyArrayOfOptionalStrings: [String] = []
    var emptyArrayOfObjects: [EmployeeForTesting] = []
    var emptyArrayOfOptionalObjects: [EmployeeForTesting?] = []
    var emptyArrayOfDoubles: [Double] = []
    var emptyArrayOfOptionalDoubles: [Double?] = []
    var emptyArrayOfFloats: [Float] = []
    var emptyArrayOfOptionalFloats: [Float?] = []
    var emptyArrayOfBools: [Float] = []
    var emptyArrayOfOptionalBools: [Float?] = []
    var emptyArrayOfDates: [Float] = []
    var emptyArrayOfOptionalDates: [Float?] = []
    var emptyArrayOfImages: [UIImage] = []
    var emptyArrayOfOptionalImages: [UIImage?] = []
    
    required init() {}
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        type <~> (map["type"], TypeConverter())
        data <~> map["data"]
        mandatoryData <~> map["mandatoryData"]
        optionalData <~> map["optionalData"]
        string <~> map["string"]
        optionalString <~> map["optionalString"]
        object <~> map["object"]
        optionalObject <~> map["optionalObject"]
        integer <~> map["integer"]<<
        optionalInteger <~> map["optionalInteger"]
        double <~> map["double"]
        optionalDouble <~> map["optionalDouble"]
        float <~> map["float"]
        optionalFloat <~> map["optionalFloat"]
        bool <~> map["bool"]
        optionalBool <~> map["optionalBool"]
        date <~> map["date"]
        optionalDate <~> map["optionalDate"]
        image <~> map["image"]
        optionalImage <~> map["optionalImage"]
        arrayOfStrings <~> map["arrayOfStrings"]
        arrayOfOptionalStrings <~> map["arrayOfOptionalStrings"]
        optionalArrayOfStrings <~> map["optionalArrayOfStrings"]
        optionalArrayOfOptionalStrings <~> map["optionalArrayOfOptionalStrings"]
        arrayOfData <~> map["arrayOfData"]
        arrayOfOptionalData <~> map["arrayOfOptionalData"]
        optionalArrayOfData <~> map["optionalArrayOfData"]
        optionalArrayOfOptionalData <~> map["optionalArrayOfOptionalData"]
        arrayOfObjects <~> map["arrayOfObjects"]
        arrayOfOptionalObjects <~> map["arrayOfOptionalObjects"]
        optionalArrayOfObjects <~> map["optionalArrayOfObjects"]
        optionalArrayOfOptionalObjects <~> map["optionalArrayOfOptionalObjects"]
        arrayOfIntegers <~> map["arrayOfIntegers"]
        arrayOfOptionalIntegers <~> map["arrayOfOptionalIntegers"]
        optionalArrayOfIntegers <~> map["optionalArrayOfIntegers"]
        optionalArrayOfOptionalIntegers <~> map["optionalArrayOfOptionalIntegers"]
        arrayOfDoubles <~> map["arrayOfDoubles"]
        arrayOfOptionalDoubles <~> map["arrayOfOptionalDoubles"]
        optionalArrayOfDoubles <~> map["optionalArrayOfDoubles"]
        optionalArrayOfOptionalDoubles <~> map["optionalArrayOfOptionalDoubles"]
        arrayOfFloats <~> map["arrayOfFloats"]
        arrayOfOptionalFloats <~> map["arrayOfOptionalFloats"]
        optionalArrayOfFloats <~> map["optionalArrayOfFloats"]
        optionalArrayOfOptionalFloats <~> map["optionalArrayOfOptionalFloats"]
        arrayOfBools <~> map["arrayOfBools"]
        arrayOfOptionalBools <~> map["arrayOfOptionalBools"]
        optionalArrayOfBools <~> map["optionalArrayOfBools"]
        optionalArrayOfOptionalBools <~> map["optionalArrayOfOptionalBools"]
        arrayOfDates <~> map["arrayOfDates"]
        arrayOfOptionalDates <~> map["arrayOfOptionalDates"]
        optionalArrayOfDates <~> map["optionalArrayOfDates"]
        optionalArrayOfOptionalDates <~> map["optionalArrayOfOptionalDates"]
        arrayOfImages <~> map["arrayOfImages"]
        arrayOfOptionalImages <~> map["arrayOfOptionalImages"]
        optionalArrayOfImages <~> map["optionalArrayOfImages"]
        optionalArrayOfOptionalImages <~> map["optionalArrayOfOptionalImages"]
        nilString <~> map["nilString"]
        nilObject <~> map["nilObject"]
        nilInteger <~> map["nilInteger"]
        nilDouble <~> map["nilDouble"]
        nilFloat <~> map["nilFloat"]
        nilBool <~> map["nilBool"]
        nilDate <~> map["nilDate"]
        nilImage <~> map["nilImage"]
        nilArrayOfStrings <~> map["nilArrayOfStrings"]
        nilArrayOfOptionalStrings <~> map["nilArrayOfOptionalStrings"]
        nilArrayOfObjects <~> map["nilArrayOfObjects"]
        nilArrayOfOptionalObjects <~> map["nilArrayOfOptionalObjects"]
        nilArrayOfDoubles <~> map["nilArrayOfDoubles"]
        nilArrayOfOptionalDoubles <~> map["nilArrayOfOptionalDoubles"]
        nilArrayOfFloats <~> map["nilArrayOfFloats"]
        nilArrayOfOptionalFloats <~> map["nilArrayOfOptionalFloats"]
        nilArrayOfBools <~> map["nilArrayOfBools"]
        nilArrayOfOptionalBools <~> map["nilArrayOfOptionalBools"]
        nilArrayOfDates <~> map["nilArrayOfDates"]
        nilArrayOfOptionalDates <~> map["nilArrayOfOptionalDates"]
        nilArrayOfImages <~> map["nilArrayOfImages"]
        nilArrayOfOptionalImages <~> map["nilArrayOfOptionalImages"]
        emptyArrayOfStrings <~> map["emptyArrayOfStrings"]
        emptyArrayOfOptionalStrings <~> map["emptyArrayOfOptionalStrings"]
        emptyArrayOfObjects <~> map["emptyArrayOfObjects"]
        emptyArrayOfOptionalObjects <~> map["emptyArrayOfOptionalObjects"]
        emptyArrayOfDoubles <~> map["emptyArrayOfDoubles"]
        emptyArrayOfOptionalDoubles <~> map["emptyArrayOfOptionalDoubles"]
        emptyArrayOfFloats <~> map["emptyArrayOfFloats"]
        emptyArrayOfOptionalFloats <~> map["emptyArrayOfOptionalFloats"]
        emptyArrayOfBools <~> map["emptyArrayOfBools"]
        emptyArrayOfOptionalBools <~> map["emptyArrayOfOptionalBools"]
        emptyArrayOfDates <~> map["emptyArrayOfDates"]
        emptyArrayOfOptionalDates <~> map["emptyArrayOfOptionalDates"]
        emptyArrayOfImages <~> map["emptyArrayOfImages"]
        emptyArrayOfOptionalImages <~> map["emptyArrayOfOptionalImages"]
    }
    
    
    func fillData() {
        var employees: [EmployeeForTesting] = []
        
        for i in 0...5 {
            let employee = EmployeeForTesting()
            employee.id = "EMP\(i)"
            employee.firstName = "Nour\(i)"
            employees.append(employee)
        }
        type = .manager
        data = "Testing Data".data(using: .utf8)
        mandatoryData = "Testing Mandatory Data".data(using: .utf8) ?? Data()
        optionalData = "Testing Optional Data".data(using: .utf8)
        string = "string"
        optionalString = "optionalString"
        object = employees[0]
        optionalObject = employees[1]
        integer = 1
        optionalInteger = 2
        double = 3
        optionalDouble = 4
        float = 5
        optionalFloat = 6
        bool = true
        optionalBool = true
        date = Date()
        optionalDate = Date()
        image = UIImage(named: "image")!
        optionalImage = UIImage(named: "image")
        arrayOfStrings = ["string1", "string2"]
        arrayOfOptionalStrings = ["string3", nil]
        optionalArrayOfStrings = ["string4", "string6"]
        optionalArrayOfOptionalStrings = ["string7", nil]
        arrayOfData = ["Testing Array Of Data".data(using: .utf8)!]
        arrayOfOptionalData = ["Testing Array Of Optional Data".data(using: .utf8), nil]
        optionalArrayOfData = ["Testing Optional Array Of Data".data(using: .utf8)!]
        optionalArrayOfOptionalData = ["Testing Optional Array Of Optional Data".data(using: .utf8), nil]
        arrayOfObjects = [employees[2]]
        arrayOfOptionalObjects = [employees[3], nil]
        optionalArrayOfObjects = [employees[4]]
        optionalArrayOfOptionalObjects = [employees[5], nil]
        arrayOfIntegers = [1, 2]
        arrayOfOptionalIntegers = [2, nil]
        optionalArrayOfIntegers = [1, 2]
        optionalArrayOfOptionalIntegers = [2, nil]
        arrayOfDoubles = [3, 4]
        arrayOfOptionalDoubles = [4, nil]
        optionalArrayOfDoubles = [3, 4]
        optionalArrayOfOptionalDoubles = [4, nil]
        arrayOfFloats = [5, 6]
        arrayOfOptionalFloats = [6, nil]
        optionalArrayOfFloats = [5, 6]
        optionalArrayOfOptionalFloats = [6, nil]
        arrayOfBools = [true, false]
        arrayOfOptionalBools = [true, nil]
        optionalArrayOfBools = [true, false]
        optionalArrayOfOptionalBools = [true, nil]
        arrayOfDates = [Date(), Date()]
        arrayOfOptionalDates = [Date(), nil]
        optionalArrayOfDates = [Date(), Date()]
        optionalArrayOfOptionalDates = [Date(), nil]
        arrayOfImages = [UIImage(named: "image")!, UIImage(named: "image")!]
        arrayOfOptionalImages = [UIImage(named: "image"), nil]
        optionalArrayOfImages = [UIImage(named: "image")!, UIImage(named: "image")!]
        optionalArrayOfOptionalImages = [UIImage(named: "image"), nil]
    }
    
    func printEmployer() {
        let mirror = Mirror(reflecting: self)
        for (_, value) in mirror.children.enumerated() {
            print("\(value.label ?? "\"\""): \(String(describing: value.value))")
        }
    }
}


class MandatoryClass: SundeedQLiter {
    var id: String = "qwe"
    var firstName: String?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        firstName <*> map["firstName"]
    }
}


class ClassContainingAMandatoryOptionalClassInArray: SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass?] = []
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <~> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryOptionalClassInOptionalArray: SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <~> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryClassInArray: SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass] = []
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <~> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryClassInOptionalArray: SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <~> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryOptionalClass: SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: MandatoryClass?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <~> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryClass: SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: MandatoryClass = MandatoryClass()
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <~> map["mandatoryClasses"]
    }
}



class ClassContainingParameterIndex: SundeedQLiter {
    var index: String?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        index <~> map["index"]+
    }
}



class NonSundeedQLiterClass {
    var firstName: String?
}
