//
//  DVNetworkTests.swift
//  DVNetworkTests
//
//  Created by David Vallas on 7/25/19.
//  Copyright © 2019 David Vallas. All rights reserved.
//

import XCTest
@testable import DVNetwork

class DVNetworkTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func register() throws {
        do {
            let shared = EntityRegister.shared
            try shared.register(ComplexCodable.self)
            try shared.register(Person.self)
            try shared.register(Company.self)
            try shared.register(PersonStruct.self)
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }
    
    func testRegister() {
        do {
            try register()
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }
    
    func testValidateGood() {
        do {
            try Person.validate(json: person1JSON)
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }
    
    func testValidateBad() {
        do {
            try Person.validate(json: person3JSON)
            XCTAssert(false, "did not produce error for validation")
        } catch {}
    }
    
    /// tests basic encoding
    func testEncodeJSON() {
        do {
            let p1 = try person1.encodeJSON()
            XCTAssert(isSame(p1, person1JSON), "did not successfully encode person1")
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }

    /// tests dvEntity that contains dvEntitys
    func testEncode2() {
        do {
            let c1 = try complex.encodeJSON()
            XCTAssert(isSame(c1, complex1JSON), "did not properly encode complex1:\n\(c1)")
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }
    
    func testEncodeArray() {
        do {
            let array = [person1, person2]
            let _ = try array.encodeJSON()
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }
    
    func testEncodeSet() {
        do {
            var set: Set<Person> = Set()
            set.insert(person1)
            set.insert(person2)
            let _ = try set.encodeJSON()
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }
    
    func testDecode() {
        do {
            let decoded: ComplexCodable = try decode(json: complex1JSON)
            let encoded = try decoded.encodeJSON()
            XCTAssert(isSame(encoded, complex1JSON), "did not successfully decode/encode complex1JSON")
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }
    
    func testDecodeArray() {
        do {
            let decoded: [Person] = try decode(json: employeesJSON)
            let encoded = try decoded.encodeJSON()
            XCTAssert(isSame(encoded, employeesJSON), "did not successfully decode/encode employeesJSON")
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }
    
    func testDecodeSet() {
        do {
            let decoded: Set<Person> = try decode(json: employeesJSON)
            let encoded = try decoded.encodeJSON()
            XCTAssert(isSame(encoded, employeesJSON), "did not successfully decode/encode employeesJSON - This is a set so isSame may be failing due to order")
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }
    
    func testSaveDefaults() {
        do {
            try complex.saveDefaults()
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }
    
    func testSaveDefaultsArray() {
        do {
            let array = [person1, person2]
            try array.saveDefaults()
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }
    
    func testSaveDefaultsSet() {
        do {
            var set: Set<Person> = Set()
            set.insert(person1)
            set.insert(person2)
            try set.saveDefaults()
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }
    
    func testOpenDefaults() {
        do {
            try complex.saveDefaults()
            let opened: ComplexCodable = try openDefaults()
            XCTAssert(opened.id == complex.id, "did not successfully open defaults")
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }
    
    func testOpenDefaultsArray() {
        do {
            let array = [person1, person2]
            try array.saveDefaults()
            let opened: [Person] = try openDefaults()
            XCTAssert(opened.count == 2, "did not successfully open defaults")
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }
    
    func testOpenDefaultsSet() {
        do {
            var set: Set<Person> = Set()
            set.insert(person1)
            set.insert(person2)
            try set.saveDefaults()
            let opened: Set<Person> = try openDefaults()
            XCTAssert(opened.count == 2, "did not successfully open defaults")
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }
    
    
    

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
