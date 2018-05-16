@testable import BitcoinRExchange
@testable import CommonLibrary
import Foundation
import XCTest

struct Sample: Codable, Equatable {
    let string: String
    let int: Int
    let float: Float
    let bool: Bool
}

class JsonParserTests: UnitTest {
    func testValidDecode() {
        let jsonString = """
        {
            "string": "A---A",
            "int": 2,
            "float": 9.2,
            "bool": true
        }
        """

        let result: Result<Sample> = JsonParser.decode(jsonString.data(using: .utf8)!)
        guard case let .success(sample) = result else {
            XCTFail("Unexpected parser error: \(result)")
            return
        }

        XCTAssertEqual(sample.string, "A---A")
        XCTAssertEqual(sample.int, 2)
        XCTAssertEqual(sample.float, 9.2, accuracy: 0.000_000_000_1)
        XCTAssertEqual(sample.bool, true)
    }

    func testInvalidDecode() {
        let jsonString = """
        {
            "stringg": "A---A",
            "int": 2,
            "float": 9.2,
            "bool": true
        }
        """

        let result: Result<Sample> = JsonParser.decode(jsonString.data(using: .utf8)!)
        guard case .error = result else {
            XCTFail("Unexpected parser success: \(result)")
            return
        }
    }
}
