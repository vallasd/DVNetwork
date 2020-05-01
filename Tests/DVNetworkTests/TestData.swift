//
//  File.swift
//
//
//  Created by David Vallas on 4/10/20.
//

import Foundation
@testable import DVNetwork

// MARK: Class Definitions

enum Gender: Int16, Enum {
    case male
    case female
}

final class Person: Entity {
    let id: UUID
    let firstName: String
    let lastName: String
    let gender: Gender
    let age: Int16
    
    init() {
        self.id = UUID()
        self.firstName = ""
        self.lastName = ""
        self.gender = .male
        self.age = 0
    }
    
    init(with keys: EntityKeys) {
        self.id = keys["id"] as! UUID
        self.firstName = keys["firstName"] as! String
        self.lastName = keys["lastName"] as! String
        self.gender = keys["gender"] as! Gender
        self.age = keys["age"] as! Int16
    }
    
    init(id: String, firstName: String, lastName: String, gender: Gender, age: Int) {
        self.id = UUID(uuidString: id)!
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.age = Int16(age)
    }
}

extension Person: Hashable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// PERSON
let person1ID = "A53395A6-3318-4D4E-A777-2A21E10F8DC0"
let person1FName = "David"
let person1LName = "Vallas"
let person1Gender = Gender.male
let person1Age = 42

struct PersonStruct: Entity {
    let id: UUID
    let firstName: String
    let lastName: String
    let age: Int16
    
    init() {
        self.id = UUID(uuidString: person1ID)!
        self.firstName = person1FName
        self.lastName = person1LName
        self.age = Int16(person1Age)
    }
    
    init(with keys: EntityKeys) {
        self.id = keys["id"] as! UUID
        self.firstName = keys["firstName"] as! String
        self.lastName = keys["lastName"] as! String
        self.age = keys["age"] as! Int16
    }
}

final class Company: Entity {
    var id: UUID = UUID()
    var name: String = ""
    var employees: [UUID] = []
    
    init() {}
    
    init(id: String, name: String, employees: [String]) {
        self.id = UUID(uuidString: id)!
        self.name = name
        self.employees = employees.map { UUID(uuidString: $0)! }
    }
    
    init(with keys: EntityKeys) {
        self.id = keys["id"] as! UUID
        self.name = keys["name"] as! String
        self.employees = keys["employees"] as! [UUID]
    }
}

final class ComplexCodable: Entity {
    var id: UUID = UUID()
    var bool: Bool = false
    var date: Date = Date()
    var double: Double = 0
    var float: Float = 0
    var int: Int = 0
    var int16: Int16 = 0
    var int32: Int32 = 0
    var int64: Int64? = nil
    var string: String = ""
    var url: URL = URL(string: "https://www.google.com")!
    var uuid: UUID = UUID()
    var optional: Date? = nil
    var array1: [Double] = []
    var array2: [Int16]? = []
    var set1: Set<Int16> = []
    var set2: Set<Date> = []
    
    init() {}
    
    init(with keys: EntityKeys) {
        self.id = keys["id"] as! UUID
        self.bool = keys["bool"] as! Bool
        self.date = keys["date"] as! Date
        self.double = keys["double"] as! Double
        self.float = keys["float"] as! Float
        self.int = keys["int"] as! Int
        self.int16 = keys["int16"] as! Int16
        self.int32 = keys["int32"] as! Int32
        self.int64 = keys["int64"] as? Int64
        self.string = keys["string"] as! String
        self.url = keys["url"] as! URL
        self.uuid = keys["uuid"] as! UUID
        self.optional = keys["optional"] as? Date
        self.array1 = keys["array1"] as! [Double]
        self.array2 = keys["array2"] as? [Int16]
        self.set1 = keys["set1"] as! Set<Int16>
        self.set2 = keys["set2"] as! Set<Date>
    }
    
    init(id: String, bool: Bool, date: Date, double: Double, float: Float, int: Int, int16: Int16, int32: Int32, int64: Int64?, string: String, url: String, uuid: String, optional: Date?, array1: [Double], array2: [Int16]?, set1: Set<Int16>, set2: Set<Date>) {
        self.id = UUID(uuidString: id)!
        self.bool = bool
        self.date = date
        self.double = double
        self.float = float
        self.int = int
        self.int16 = int16
        self.int32 = int32
        self.int64 = int64
        self.string = string
        self.url = URL(string: url)!
        self.uuid = UUID(uuidString: uuid)!
        self.optional = optional
        self.array1 = array1
        self.array2 = array2
        self.set1 = set1
        self.set2 = set2
    }
}

// MARK: Default Variables

// PERSON
let person2ID = "EBE21A4C-3DB8-4209-8F7A-178307DF67FA"
let person2FName = "Lucia"
let person2LName = "Rolim"
let person2Gender = Gender.female
let person2Age = 33
let person3ID = "592376F2-B23E-487F-A109-6DF3EDF933B0"
let person3FName = "Joe"
let person3LName = "Shmo"
let person3Gender = Gender.male
let person3Age = 999999999777

// COMPANY
let compan1ID = "5323C209-919E-4B92-B366-0B23A082EF08"
let compan1Name = "5323C209-919E-4B92-B366-0B23A082EF08"

// COMPLEXEntity
let CCId: String = "267FEB1D-DB43-4B16-A1E5-F574B9AD2B6D"
let CCbool: Bool = false
let CCdate: String = "1978-02-12T12:00:00+0000"
let CCdate_2: String = "1964-05-05T15:30:30+0000"
let CCdouble: Double = 100.5
let CCdouble_2: Double = 100.512348213
let CCfloat: Float = 50.598891324
let CCint: Int = 123456789
let CCint16: Int16 = 136
let CCint16_2: Int16 = 139
let CCint32: Int32 = 1001230
let CCint64: Int64 = 123981238
let CCstring: String = "Test String 😍"
let CCurl: String = "https://www.google.com"
let CCuuid: String = "5323C209-919E-4B92-B366-0B23A082EF08"
let CCoptional: Date? = nil
let CCarray1: [Double] = [CCdouble, CCdouble_2]
let CCset1: Set<Int16> = [CCint16, CCint16_2]
let d1: Date = Date.decodeJSON(CCdate)!
let d2: Date = Date.decodeJSON(CCdate_2)!
let CCset2: Set<Date> = [d1, d2]

// MARK: OBJECTS

let person1 = Person(id: person1ID, firstName: person1FName, lastName: person1LName, gender: person1Gender, age: person1Age)
let person2 = Person(id: person2ID, firstName: person2FName, lastName: person2LName, gender: person2Gender, age: person2Age)
let person3 = Person(id: person3ID, firstName: person3FName, lastName: person3LName, gender: person3Gender, age: person3Age)
let personStruct = PersonStruct()
let employees = [person1ID, person2ID]
let compan1 = Company(id: compan1ID, name: compan1Name, employees: employees)
let complex = ComplexCodable(id: CCId, bool: CCbool, date: d1, double: CCdouble, float: CCfloat, int: CCint, int16: CCint16, int32: CCint32, int64: nil, string: CCstring, url: CCurl, uuid: CCuuid, optional: CCoptional, array1: CCarray1, array2: nil, set1: CCset1, set2: CCset2)

// MARK: JSON

let person1JSON: JSON = [
    "id": person1ID,
    "firstName": person1FName,
    "lastName": person1LName,
    "gender": 0,
    "age": person1Age,
]

let person2JSON: JSON = [
    "id": person2ID,
    "firstName": person2FName,
    "lastName": person2LName,
    "gender": 1,
    "age": person2Age,
]

// should create an error
let person3JSON: JSON = [
    "id": person3ID,
    "firstName": person3FName,
    "lastName": person3LName,
    "gender": 0,
    "age": person3Age,
]


let employeesJSON: JSON = [
    person1JSON,
    person2JSON,
]

let compan1JSON: JSON = [
    "id": compan1ID,
    "name": compan1Name,
    "employees": employeesJSON
]

// should create an error
let compan2JSON: JSON = [
    "id": compan1ID,
    "name": compan1Name,
    "employees": [
        person1JSON,
        person2JSON,
        person3JSON,
    ]
]

let complex1JSON: JSON = [
    "id": CCId,
    "bool": CCbool,
    "date": CCdate,
    "double": CCdouble,
    "float": Double(CCfloat),
    "int": CCint,
    "int16": Int(CCint16),
    "int32": Int(CCint32),
    "string": CCstring,
    "url": CCurl,
    "uuid": CCuuid,
    "array1": CCarray1,
    "set1": [Int(CCint16), Int(CCint16_2)],
    "set2": [CCdate, CCdate_2]
]

