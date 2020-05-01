import XCTest
@testable import DVNetwork

class TestUserDefaults: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
}
