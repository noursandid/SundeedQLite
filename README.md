# SundeedQLite
[![Build Status](https://travis-ci.org/SundeedQLite/SundeedQLite.svg?branch=master)](https://travis-ci.org/Alamofire/Alamofire) [![CocoaPods Compatible](https://img.shields.io/cocoapods/v/SundeedQLite.svg)](https://cocoapods.org/pods/SundeedQLite) [![Platform](https://img.shields.io/cocoapods/p/SundeedQLite.svg?style=flat)](https://noursandid.github.io/SundeedQLite) [![License](https://img.shields.io/cocoapods/l/MarkdownKit.svg?style=flat)](http://cocoapods.org/pods/SundeedQLite)

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
**+** : It's used to mark the primary key in the database.
*N.B*
- Primary keys should always be strings.
- To create a nested object (**e.g: Employee**), **Employer** should have a primary key to link it as a foreign key.

**<<** : It's used to mark the *ASCENDING* sorting method

**>>** : It's used to mark the *DESCENDING* sorting method

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
    override func viewDidLoad() {
        super.viewDidLoad()
        let employee = Employee()
        employee.firstName = "Nour"

        let employer = Employer()
        employer.id = "ABCD-1234-EFGH-5678"
        employer.fullName = "Nour Sandid"
        employer.employees = [employee]

        employer.save()
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
# Built Using
*SQLite3*



License
--------

MIT


**Free Software, Hell Yeah!**
