import XCTest
@testable import DVNetwork

class TestValidatoin: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
}
