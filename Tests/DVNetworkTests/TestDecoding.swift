import XCTest
@testable import DVNetwork

class TestDecoding: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
            XCTAssert(encoded.count == 2, "did not successfully decode/encode employeesJSON")
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }
    
}
