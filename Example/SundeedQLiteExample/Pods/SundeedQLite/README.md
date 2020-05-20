![Sundeed](https://raw.githubusercontent.com/noursandid/SundeedQLite/master/SundeedLogo.png)

# SundeedQLite
[![Build Status](https://travis-ci.org/noursandid/SundeedQLite.svg?branch=master)](https://travis-ci.org/noursandid/SundeedQLite) [![codecov.io](https://codecov.io/gh/noursandid/SundeedQLite/branch/master/graph/badge.svg)](https://codecov.io/gh/noursandid/SundeedQLite/branch/master) [![CocoaPods Compatible](https://img.shields.io/cocoapods/v/SundeedQLite.svg)](https://cocoapods.org/pods/SundeedQLite) [![Platform](https://img.shields.io/cocoapods/p/SundeedQLite.svg?style=flat)](https://noursandid.github.io/SundeedQLite) [![License](https://img.shields.io/cocoapods/l/MarkdownKit.svg?style=flat)](http://cocoapods.org/pods/SundeedQLite) [![Language](https://img.shields.io/badge/Language-Swift-brightgreen)](https://github.com/apple/swift) [![Last Commit](https://img.shields.io/github/last-commit/noursandid/SundeedQLite?style=flat)](https://github.com/noursandid/SundeedQLite) [![HitCount](http://hits.dwyl.com/noursandid/SundeedQLite.svg?style=flat)](http://hits.dwyl.com/noursandid/SundeedQLite)

##### SundeedQLite is the easiest offline database integration, built using Swift language
# Requirements
- ##### iOS 12.0+
- ##### XCode 10.3+
- ##### Swift 5+
### Installation
----
### Installation via CocoaPods

SundeedQLite is available through [CocoaPods](http://cocoapods.org). CocoaPods is a dependency manager that automates and simplifies the process of using 3rd-party libraries like MarkdownKit in your projects. You can install CocoaPods with the following command:

```bash
gem install cocoapods
```

To integrate SundeedQLite into your Xcode project using CocoaPods, simply add the following line to your Podfile:

```bash
pod "SundeedQLite"
```

Afterwards, run the following command:

```bash
pod install
```
# Signs
- **+** : It's used to mark the primary key in the database.
- **<<** : It's used to mark the *ASCENDING* sorting method
- **>>** : It's used to mark the *DESCENDING* sorting method
- **<~>** : It's used to map between objects returned from the database to specific property
- **<\*>** : It's used to state that if this property is returned nil from the database, the whole parent object shall be dropped.
- **<\*\*>** : It's used to state that if this array was empty, or one of the elements was mandatory ( **<\*>** ), the whole parent object shall be dropped

*N.B:*
- Primary keys should always be strings.
- To create a nested object (**e.g: Employee**), both **Employer** and **Employee** should have primary keys.

# Supported Types
- SundeedQLiter Objects
- String
- Int
- Double
- Float
- Bool
- Date
- UIImage
- Array
- enum/struct (see below documentation)

*P.S:*
- *Nested objects will be normally saved*
- *Optional and non-optional values of the above mentioned types will also be saved*
- *Arrays of objects or primitive data type will be saved*
- *No nil returned value from the database shall be added to an array while retrieving*

# Listeners
To Listen to events happening you can always add any listener with a block of code to be executed when the event happens.

### Supported Events
- Save
- Update
- Retrieve
- Delete
- AllEvents

*P.S:*
Always remember to save an instance of this listener to stop it whenever it's not needed anymore.

# Documentation
```swift
import SundeedQLite

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
class Employee: SundeedQLiter {
    var id: String!
    var firstName: String?
    required init() {}
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]
        firstName <~> map["firstName"]
    }
}
```

```swift
import UIKit

class ViewController: UIViewController {
    var employerSaveListener: Listener?
    override func viewDidLoad() {
        super.viewDidLoad()
        let employee = Employee()
        employee.firstName = "Nour"

        let employer = Employer()
        employer.id = "ABCD-1234-EFGH-5678"
        employer.fullName = "Nour Sandid"
        employer.employees = [employee]
        employerSaveListener = employer.onSaveEvents({ (object) in 
            print(object.id)
        })
        employer.save()
    }
    
    deinit {
        employerSaveListener.stop()
    }
}
```

### Custom Types
To save variables with custom types like enum or struct, you can use SundeedQLiteConverter
```swift
class TypeConverter: SundeedQLiteConverter {
    func fromString(value: String) -> Any? {
       return Type(rawValue: value)
    }
    func toString(value: Any?) -> String? {
        return (value as? Type)?.rawValue
    }
}

enum Type: String {
    case manager
    case ceo
}

class Employer: SundeedQLiter {
    var type: Type?
    
    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        type <~> (map["type"], TypeConverter())
    }
}
```
# CheatSheet
### To Save
```swift
employer.save()
```
### To Retrieve
```swift
Employer.retrieve { (employers) in
    for employer in employers {
        print(employer.fullName)
    }
}

Employer.retrieve(withFilter: SundeedColumn("fullName") == "Nour Sandid",
                  orderBy: SundeedColumn("fullName"),
                  ascending: true) { (employers) in
    for employer in employers {
        print(employer.fullName)
    }
}
```
### To Reset The Database
```swift
SundeedQLite.deleteDatabase()
```
# Built Using
*SQLite3*

License
--------
MIT

