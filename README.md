![Sundeed](https://raw.githubusercontent.com/noursandid/SundeedQLite/master/SundeedLogo.png)

# SundeedQLite
[![codecov.io](https://codecov.io/gh/noursandid/SundeedQLite/branch/master/graph/badge.svg)](https://codecov.io/gh/noursandid/SundeedQLite/branch/master) [![Language](https://img.shields.io/badge/Language-Swift-brightgreen)](https://github.com/apple/swift) [![Last Commit](https://img.shields.io/github/last-commit/noursandid/SundeedQLite?style=flat)](https://github.com/noursandid/SundeedQLite)

##### SundeedQLite is the easiest offline database integration, built using Swift language
# Requirements
- ##### iOS 13.0+
- ##### XCode 10.3+
- ##### Swift 5+
### Installation
----

### Installation via Swift Package Manager
To install SundeedQLite using SPM, 
```swift
dependencies: [
  .package(
    url: "https://github.com/noursandid/SundeedQLite.git",
    from: "3.0.0"
  ),
]
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
- Data
- enum/struct (see below documentation)

*P.S:*
- *Nested objects will be normally saved*
- *Optional and non-optional values of the above mentioned types will also be saved*
- *Arrays of objects or primitive data type will be saved*
- *No nil returned value from the database shall be added to an array while retrieving*

# Listeners
To Listen to events happening you can always add any listener with a block of code to be executed when the event happens.

##### Supported Listener Events
- Save
- Update
- Retrieve
- Delete
- AllEvents

*P.S:*
Always remember to save an instance of this listener to stop it whenever it's not needed anymore.

# Documentation
### Prepare
To prepare your Models, you need the class to conform to `SundeedQLiter` which has two mandatory functions
```swift
public protocol SundeedQLiter: AnyObject {
    /** A function that describes all the mappings between database and object */
    func sundeedQLiterMapping(map: SundeedQLiteMap)
    init()
}
```

this mapping will have all the details that the library needs to create the corresponding SQLite tables.

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
        id <~> map["id"]+
        firstName <~> map["firstName"]
    }
}
```

### Save

To save an instance of a Model, you just need to call `.save(withForeignKey foreignKey: String? = nil)` function on the instance itself and it should be sufficient to create the table with the right columns and propagate the data, and of course call the right listeners (mentioned at a later stage in this documentation).
To save an instance of a Model, you just need to call `.save(withForeignKey foreignKey: String? = nil)` function on the instance itself and it should be sufficient to create the table with the right columns and propagate the data, and of course call the right listeners (mentioned at a later stage in this documentation).
The foreign key gives the ability to save a specific instance and link it to another one.

```swift
let employer = Employer()
employer.id = "ABCD-1234-EFGH-5678"
employer.fullName = "Nour Sandid"
employer.save()

let employee = Employee()
employee.firstName = "Nour"
await employee.save(withForeignKey: "ABCD-1234-EFGH-5678")
```

You can also save an array of `SundeedQLiter` objects
```swift
let employer1 = Employer()
employer1.id = "ABCD-1234-EFGH-5678"
employer1.fullName = "Nour Sandid"

let employer2 = Employer()
employer2.id = "IJKL-9123-MNOP-4567"
employer2.fullName = "Test Employer"

// time to save
let employers = [employer1, employer2]
await employers.save()
```

### Update
To update an instance of a Model, you need to update the value in that instance, and then call the `update(columns: SundeedColumn...) throws` function. This will update the instance value in the database, and of course call the right listeners (mentioned at a later stage in this documentation).

```swift
let employer = Employer()
employer.id = "ABCD-1234-EFGH-5678"
employer.fullName = "Nour Sandid"
employer.save()

employer.fullName = "Test"
await employer.update(columns: SundeedColumn("fullName")) // this string should be exactly as the one in the `sundeedQLiterMapping` function.
```

To update all instances of the same type from the database, you can call the static function `update(changes: SundeedUpdateSetStatement..., withFilter filter: SundeedExpression<Bool>? = nil) async throws)` that would update specific columns for all the rows respecting the filters.

```swift
let employer = Employer()
employer.id = "ABCD-1234-EFGH-5678"
employer.fullName = "Nour Sandid"
await employer.save()

// time to update
do {
    try await CoreUser.update(changes: SundeedColumn("fullName") <~ "Test",
                                 withFilter: SundeedColumn("fullName") == "Nour Sandid")
} catch {
    print(error)
}
```

### Delete
To delete an instance, you need to call the `delete(deleteSubObjects: Bool = false) async throws -> Bool` function that will delete the instance from the database and return a boolean if it was deleted or not, and of course call the right listeners (mentioned at a later stage in this documentation).
You can use `deleteSubObjects` to propagate the deletion of the object to it's sub-objects (in the properties)
```swift
let employer = Employer()
employer.id = "ABCD-1234-EFGH-5678"
employer.fullName = "Nour Sandid"
await employer.save()

// time to delete
await employer.delete()
```

To delete all the instances of the same type from the database, you can call the static function `delete(withFilter filters: SundeedExpression<Bool>...)`, you can also pass filters to be more specific.
```swift
let employer = Employer()
employer.id = "ABCD-1234-EFGH-5678"
employer.fullName = "Nour Sandid"
await employer.save()

// time to delete
await employer.delete(withFilter: SundeedColumn("fullName") == "Nour Sandid") 
```

### Retrieve
To retrieve instances saved previously in the database, you need to call the static function  `.retrieve(withFilter filter: SundeedExpression<Bool>? = nil, orderBy order: SundeedColumn? = nil, ascending asc: Bool = true, excludeIfIsForeign: Bool = false) async -> [Self]`, which will retrieve all the instance of that type respecting the filters and the order. `excludeIfIsForeign` is responsible to exclude all the instances that are related to other instances (values for properties in other instances)

```swift
 let employee = Employee()
 employee.firstName = "Nour"
     
let employer = Employer()
employer.id = "ABCD-1234-EFGH-5678"
employer.fullName = "Nour Sandid"
employer.employees = [employee]
employer.save()

let data = await Employee.retrieve()
print(data) // [Employee(firstName: "Nour")]

// now since employee is not an independent instance, it will be excluded from the below result.
let data = await Employee.retrieve(excludeIfIsForeign: true)
print(data) // []

let data = await Employee.retrieve(withFilter: SundeedColumn("firstName") == "Nour", excludeIfIsForeign: true)
print(data) // [Employee(firstName: "Nour")]

let data = await Employer.retrieve(withFilter: SundeedColumn("fullName") == "Nour Sandid", orderBy: SundeedColumn("fullName"), ascending: false, excludeIfIsForeign: true)
print(data) // [Employer(id: "ABCD-1234-EFGH-5678", firstName: "Nour", employees: [Employee(firstName: "Nour")])]
```

### Add Listeners
To add listeners, you need to call the `.on#EVENT#Events(_ function: @escaping (_ object: Self) -> Void)`, and pass a block of code that will be called whenever a specific event is triggered
###### Save Listener
The function block will be called whenever a save event happens on the database for a specific class type or an instance.
```swift
let employerSaveListener: Listener? = employer.onSaveEvents({ (object) in 
    print(object.id)
})
let allEmployersSaveListener: Listener? = Employer.onSaveEvents({ (object) in 
    print(object.id)
})
deinit {
    employerSaveListener?.stop()
    allEmployersSaveListener?.stop()
}
```
###### Update Listener
The function block will be called whenever an update event happens on the database for a specific class type or an instance.
```swift
let employerUpdateListener: Listener? = employer.onUpdateEvents({ (object) in 
    print(object.id)
})
let allEmployersUpdateListener: Listener? = Employer.onUpdateEvents({ (object) in 
    print(object.id)
})
deinit {
    employerUpdateListener?.stop()
    allEmployersUpdateListener?.stop()
}
```
###### Delete Listener
The function block will be called whenever a delete event happens on the database for a specific class type or an instance.
```swift
let employerDeleteListener: Listener? = employer.onDeleteEvents({ (object) in 
    print(object.id)
})
let allEmployersDeleteListener: Listener? = Employer.onDeleteEvents({ (object) in 
    print(object.id)
})
deinit {
    employerDeleteListener?.stop()
    allEmployersDeleteListener?.stop()
}
```
###### Retrieve Listener
The function block will be called whenever a retrieve event happens from the database for a specific class type or an instance.
```swift
let employerRetrieveListener: Listener? = employer.onRetrieveEvents({ (object) in 
    print(object.id)
})
let allEmployersRetrieveListener: Listener? = Employer.onRetrieveEvents({ (object) in 
    print(object.id)
})
deinit {
    employerRetrieveListener?.stop()
    allEmployersRetrieveListener?.stop()
}
```
###### All events Listener
The function block will be called on any event happening on the database for a specific class type or an instance.
```swift
let employerAllListener: Listener? = employer.onAllEvents({ (object) in 
    print(object.id)
})
let allEmployersAllListener: Listener? = Employer.onAllEvents({ (object) in 
    print(object.id)
})
deinit {
    employerAllListener?.stop()
    allEmployersAllListener?.stop()
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
await employer.save()
```
### To Retrieve
```swift
let employers = await Employer.retrieve()
for employer in employers {
    print(employer.fullName)
}

let employers = await Employer.retrieve(withFilter: SundeedColumn("fullName") == "Nour Sandid",
                  orderBy: SundeedColumn("fullName"),
                  ascending: true)
for employer in employers {
    print(employer.fullName)
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

