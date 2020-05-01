import XCTest
@testable import DVNetwork

class TestEncoding: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
}
