import XCTest
@testable import DVNetwork

class TestRegistration: XCTestCase {

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
    
}
