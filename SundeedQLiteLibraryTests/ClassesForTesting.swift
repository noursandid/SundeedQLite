//
//  EmployerForTesting.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 10/8/19.
//  Copyright © 2019 LUMBERCODE. All rights reserved.
//

import XCTest
@testable import SundeedQLiteLibrary

class EmployeeForTesting: @unchecked Sendable, SundeedQLiter {
    var id: String!
    var firstName: String?
    var integer: Int = 1
    var seniorEmployee: SeniorEmployeeForTesting?
    required init() {}
    init(id: String, seniorID: String, juniorID: String) {
        self.id = id
        self.seniorEmployee = SeniorEmployeeForTesting(id: seniorID, juniorID: juniorID)
    }
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        integer <~> map["integer"]<<
            firstName <~> map["firstName"]
        seniorEmployee <~> map["seniorEmployee"]
    }
}

class SeniorEmployeeForTesting: @unchecked Sendable, SundeedQLiter {
    var id: String!
    var firstName: String?
    var juniorEmployee: JuniorEmployeeForTesting?
    required init() {}
    init(id: String, juniorID: String) {
        self.id = id
        self.juniorEmployee = JuniorEmployeeForTesting(id: juniorID)
    }
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        firstName <~> map["firstName"]
        juniorEmployee <~> map["juniorEmployee"]
    }
}

class JuniorEmployeeForTesting: @unchecked Sendable, SundeedQLiter {
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

class EmployerForTesting: @unchecked Sendable, SundeedQLiter {
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
    var object: EmployeeForTesting = EmployeeForTesting(id: "EFGH-9012-IJKL-3456", seniorID: "EFGH-9012-IJKL-3457", juniorID: "EFGH-9012-IJKL-3458")
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
            employee.seniorEmployee = SeniorEmployeeForTesting(id: "EFGH-9012-IJKL-3456-\(i)", juniorID: "EFGH-9012-IJKL-3456-j\(i)")
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
    
    func check() {
        XCTAssertEqual(self.type, .manager)
        XCTAssertEqual(self.data, "Testing Data".data(using: .utf8))
        XCTAssertEqual(self.mandatoryData, "Testing Mandatory Data".data(using: .utf8) ?? Data())
        XCTAssertEqual(self.optionalData, "Testing Optional Data".data(using: .utf8))
        XCTAssertEqual(self.mandatoryType, .ceo)
        XCTAssertEqual(self.arrayOfTypes, [.manager, .ceo])
        XCTAssertEqual(self.optionalArrayOfTypes, [.manager, .ceo])
        XCTAssertEqual(self.optionalArrayOfOptionalTypes, [.manager, .ceo])
        XCTAssertEqual(self.arrayOfOptionalTypes, [.manager, .ceo])
        XCTAssertEqual(self.string, "string")
        XCTAssertEqual(self.optionalString, "optionalString")
        XCTAssertNotNil(self.object)
        XCTAssertNotNil(self.optionalObject)
        XCTAssertEqual(self.integer, 1)
        XCTAssertEqual(self.optionalInteger, 2)
        XCTAssertEqual(self.double, 3.0)
        XCTAssertEqual(self.optionalDouble, 4.0)
        XCTAssertEqual(self.float, 5.0)
        XCTAssertEqual(self.optionalFloat, 6.0)
        XCTAssertEqual(self.bool, true)
        XCTAssertEqual(self.optionalBool, true)
        XCTAssertNotNil(self.date)
        XCTAssertNotNil(self.optionalDate)
        XCTAssertEqual(self.image.jpegData(compressionQuality: 1)?.description,
                       UIImage(named: "1")?.jpegData(compressionQuality: 1)?.description)
        XCTAssertEqual(self.optionalImage?.jpegData(compressionQuality: 1)?.description,
                       UIImage(named: "2")?.jpegData(compressionQuality: 1)?.description)
        XCTAssertEqual(self.arrayOfStrings, ["string1", "string2"])
        XCTAssertEqual(self.arrayOfOptionalStrings, ["string3"])
        XCTAssertEqual(self.optionalArrayOfStrings, ["string4", "string6"])
        XCTAssertEqual(self.optionalArrayOfOptionalStrings, ["string7"])
        XCTAssertEqual(self.arrayOfData, ["Testing Array Of Data".data(using: .utf8)!])
        XCTAssertEqual(self.arrayOfOptionalData, ["Testing Array Of Optional Data".data(using: .utf8)])
        XCTAssertEqual(self.optionalArrayOfData, ["Testing Optional Array Of Data".data(using: .utf8)!])
        XCTAssertEqual(self.optionalArrayOfOptionalData, ["Testing Optional Array Of Optional Data".data(using: .utf8)])
        XCTAssertNotNil(self.arrayOfObjects)
        XCTAssertFalse(self.arrayOfObjects.isEmpty)
        XCTAssertNotNil(self.arrayOfOptionalObjects)
        XCTAssertNotNil(self.optionalArrayOfObjects)
        XCTAssertNotNil(self.optionalArrayOfOptionalObjects)
        XCTAssertEqual(self.arrayOfIntegers[0], 1)
        XCTAssertEqual(self.arrayOfIntegers[1], 2)
        XCTAssertEqual(self.arrayOfOptionalIntegers[0], 2)
        XCTAssertEqual(self.optionalArrayOfIntegers?[0], 1)
        XCTAssertEqual(self.optionalArrayOfIntegers?[1], 2)
        XCTAssertEqual(self.optionalArrayOfOptionalIntegers?[0], 2)
        XCTAssertEqual(self.arrayOfDoubles[0], 3.0)
        XCTAssertEqual(self.arrayOfDoubles[1], 4.0)
        XCTAssertEqual(self.arrayOfOptionalDoubles[0], 4.0)
        XCTAssertEqual(self.optionalArrayOfDoubles?[0], 3.0)
        XCTAssertEqual(self.optionalArrayOfDoubles?[1], 4.0)
        XCTAssertEqual(self.optionalArrayOfOptionalDoubles?[0], 4.0)
        XCTAssertEqual(self.arrayOfFloats[0], 5.0)
        XCTAssertEqual(self.arrayOfFloats[1], 6.0)
        XCTAssertEqual(self.arrayOfOptionalFloats[0], 6.0)
        XCTAssertEqual(self.optionalArrayOfFloats?[0], 5.0)
        XCTAssertEqual(self.optionalArrayOfFloats?[1], 6.0)
        XCTAssertEqual(self.optionalArrayOfOptionalFloats?[0], 6.0)
        XCTAssertTrue(self.arrayOfBools[0])
        XCTAssertFalse(self.arrayOfBools[1])
        XCTAssertTrue(self.arrayOfOptionalBools[0] ?? false)
        XCTAssertTrue(self.optionalArrayOfBools?[0] ?? false)
        XCTAssertFalse(self.optionalArrayOfBools?[1] ?? true)
        XCTAssertTrue(self.optionalArrayOfOptionalBools?[0] ?? false)
        XCTAssertNotNil(self.arrayOfDates)
        XCTAssertNotNil(self.arrayOfOptionalDates)
        XCTAssertNotNil(self.optionalArrayOfDates)
        XCTAssertNotNil(self.optionalArrayOfOptionalDates)
        XCTAssertNotNil(self.arrayOfImages)
        XCTAssertEqual(self.arrayOfImages.first?.jpegData(compressionQuality: 1)?.description,
                       UIImage(named: "3")?.jpegData(compressionQuality: 1)?.description)
        XCTAssertNotNil(self.arrayOfOptionalImages)
        
        XCTAssertEqual(self.arrayOfOptionalImages
            .first??.jpegData(compressionQuality: 1)?.description,
                       UIImage(named: "5")?.jpegData(compressionQuality: 1)?.description)
        XCTAssertNotNil(self.optionalArrayOfImages)
        XCTAssertNotNil(self.optionalArrayOfOptionalImages)
        XCTAssertNil(self.nilString)
        XCTAssertNil(self.nilObject)
        XCTAssertNil(self.nilInteger)
        XCTAssertNil(self.nilDouble)
        XCTAssertNil(self.nilFloat)
        XCTAssertNil(self.nilBool)
        XCTAssertNil(self.nilDate)
        XCTAssertNil(self.nilImage)
        XCTAssertNil(self.nilArrayOfStrings)
        XCTAssertNil(self.nilArrayOfOptionalStrings)
        XCTAssertNil(self.nilArrayOfObjects)
        XCTAssertNil(self.nilArrayOfOptionalObjects)
        XCTAssertNil(self.nilArrayOfDoubles)
        XCTAssertNil(self.nilArrayOfOptionalDoubles)
        XCTAssertNil(self.nilArrayOfFloats)
        XCTAssertNil(self.nilArrayOfOptionalFloats)
        XCTAssertNil(self.nilArrayOfBools)
        XCTAssertNil(self.nilArrayOfOptionalBools)
        XCTAssertNil(self.nilArrayOfDates)
        XCTAssertNil(self.nilArrayOfOptionalDates)
        XCTAssertNil(self.nilArrayOfImages)
        XCTAssertNil(self.nilArrayOfOptionalImages)
        XCTAssertEqual(self.emptyArrayOfStrings.count, 0)
        XCTAssertEqual(self.emptyArrayOfOptionalStrings.count, 0)
        XCTAssertEqual(self.emptyArrayOfObjects.count, 0)
        XCTAssertEqual(self.emptyArrayOfOptionalObjects.count, 0)
        XCTAssertEqual(self.emptyArrayOfDoubles.count, 0)
        XCTAssertEqual(self.emptyArrayOfOptionalDoubles.count, 0)
        XCTAssertEqual(self.emptyArrayOfFloats.count, 0)
        XCTAssertEqual(self.emptyArrayOfOptionalFloats.count, 0)
        XCTAssertEqual(self.emptyArrayOfBools.count, 0)
        XCTAssertEqual(self.emptyArrayOfOptionalBools.count, 0)
        XCTAssertEqual(self.emptyArrayOfDates.count, 0)
        XCTAssertEqual(self.emptyArrayOfOptionalDates.count, 0)
        XCTAssertEqual(self.emptyArrayOfImages.count, 0)
        XCTAssertEqual(self.emptyArrayOfOptionalImages.count, 0)
    }
    
    func printEmployer() {
        let mirror = Mirror(reflecting: self)
        for (_, value) in mirror.children.enumerated() {
            print("\(value.label ?? "\"\""): \(String(describing: value.value))")
        }
    }
}

class EmployerWithNoPrimaryForTesting: @unchecked Sendable, SundeedQLiter {
    var type: Type?
    var data: Data?
    var mandatoryData: Data = "Test Data".data(using: .utf8) ?? Data()
    var optionalData: Data?
    var string: String = ""
    var optionalString: String?
    var object: EmployeeForTesting = EmployeeForTesting(id: "EFGH-9012-IJKL-3456", seniorID: "EFGH-9012-IJKL-3457", juniorID: "EFGH-9012-IJKL-3458")
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


class MandatoryClass: @unchecked Sendable, SundeedQLiter {
    var id: String = "qwe"
    var firstName: String?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        firstName <*> map["firstName"]
    }
}


class ClassContainingAMandatoryOptionalClassInArray: @unchecked Sendable, SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass?] = []
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <~> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryOptionalClassInOptionalArray: @unchecked Sendable, SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass?]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <~> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryClassInArray: @unchecked Sendable, SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass] = []
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <~> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryClassInOptionalArray: @unchecked Sendable, SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: [MandatoryClass]?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <~> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryOptionalClass: @unchecked Sendable, SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: MandatoryClass?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <~> map["mandatoryClasses"]
    }
}

class ClassContainingAMandatoryClass: @unchecked Sendable, SundeedQLiter {
    var id: String = "ID"
    var mandatoryClasses: MandatoryClass = MandatoryClass()
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        mandatoryClasses <~> map["mandatoryClasses"]
    }
}



class ClassContainingParameterIndex: @unchecked Sendable, SundeedQLiter {
    var index: String?
    required init() {}
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        index <~> map["index"]+
    }
}



class NonSundeedQLiterClass {
    var firstName: String?
}
