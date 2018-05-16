@testable import BitcoinRExchange
@testable import CommonLibrary
import Foundation
import XCTest

class AnotherCollectionReusableView: UICollectionReusableView { }
class AnotherTableViewCell: UITableViewCell { }
class AnotherView: UIView { }
class AnotherViewController: UIViewController { }

class CocoaExTests: UnitTest {
    func testArraySafeSubscript() {
        let array = [1, 2, 3, 5, 8, 13]
        XCTAssertNil(array[safe: 6])
        XCTAssertNil(array[safe: 7])
        XCTAssertNil(array[safe: 8])
        XCTAssertNil(array[safe: -1])
        XCTAssertNotNil(array[safe: 0])
        XCTAssertNotNil(array[safe: 1])
        XCTAssertNotNil(array[safe: 2])
        XCTAssertNotNil(array[safe: 3])
        XCTAssertNotNil(array[safe: 4])
        XCTAssertNotNil(array[safe: 5])
        XCTAssertEqual(array[safe: 0], 1)
        XCTAssertEqual(array[safe: 1], 2)
        XCTAssertEqual(array[safe: 2], 3)
        XCTAssertEqual(array[safe: 3], 5)
        XCTAssertEqual(array[safe: 4], 8)
        XCTAssertEqual(array[safe: 5], 13)
    }

    func testDateBackToMidnight() {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm:ss"

        XCTAssertEqual(f.date(from: "2010-09-15 09:20:10")!.backToMidnight,
                       f.date(from: "2010-09-15 00:00:00")!)
        XCTAssertEqual(Date(timeIntervalSince1970: 388_416_300).backToMidnight,
                       Date(timeIntervalSince1970: 388_360_800))
    }

    func testDateAddingDays() {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm:ss"
        XCTAssertEqual(f.date(from: "2010-09-15 09:20:10")!.addingDays(7),
                       f.date(from: "2010-09-22 09:20:10")!)
        XCTAssertEqual(f.date(from: "2010-09-15 09:20:10")!.addingDays(-14),
                       f.date(from: "2010-09-01 09:20:10")!)
        XCTAssertEqual(Date(timeIntervalSince1970: 388_416_300).addingDays(2),
                       Date(timeIntervalSince1970: 388_416_300 + 2 * 24 * 60 * 60))
        XCTAssertEqual(Date(timeIntervalSince1970: 388_416_300).addingDays(-7),
                       Date(timeIntervalSince1970: 388_416_300 - 7 * 24 * 60 * 60))
    }

    func testDateFormatting() {
        let refDate = Date(timeIntervalSince1970: 388_416_300)
        let en = Locale(identifier: "en")
        let f1 = refDate.formattedFromComponents(styleAttitude: .short,
                                                 year: false,
                                                 month: true,
                                                 day: true,
                                                 hour: true,
                                                 minute: true,
                                                 second: true,
                                                 locale: en)
        let f2 = refDate.formattedFromComponents(styleAttitude: .short,
                                                 year: true,
                                                 month: true,
                                                 day: true,
                                                 hour: true,
                                                 minute: true,
                                                 second: true,
                                                 locale: en)
        XCTAssertEqual(f1, "04/23, 15:25:00")
        XCTAssertEqual(f2, "04/23/82, 15:25:00")
    }

    func testReuseIdentifier() {
        XCTAssertEqual(UICollectionReusableView.reuseIdentifier(), "UICollectionReusableView")
        XCTAssertEqual(AnotherCollectionReusableView.reuseIdentifier(), "AnotherCollectionReusableView")
        XCTAssertEqual(UITableViewCell.reuseIdentifier(), "UITableViewCell")
        XCTAssertEqual(AnotherTableViewCell.reuseIdentifier(), "AnotherTableViewCell")
    }

    func testNibName() {
        XCTAssertEqual(UIView.nibName, "UIView")
        XCTAssertEqual(AnotherView.nibName, "AnotherView")
        XCTAssertEqual(UIViewController.nibName, "UIView")
        XCTAssertEqual(AnotherViewController.nibName, "AnotherView")
    }

    func testNib() {
        let vc = HistoricalViewController()
        XCTAssertTrue(HistoricalView.nib().instantiate(withOwner: vc, options: nil).first as? HistoricalView != nil)
        XCTAssertTrue(HistoricalViewController.nib().instantiate(withOwner: vc, options: nil).first as? HistoricalView != nil)
    }

    func testStartable() {
        let sut = HistoricalViewController.start()
        XCTAssertNotNil(sut)
    }

    func testWindowHelpers() {
        let window = UIWindow.create()
        XCTAssertEqual(window.frame, UIScreen.main.bounds)

        let vc = AnotherViewController()
        window.setup(with: vc)
        XCTAssertTrue(window.isKeyWindow)
        XCTAssertEqual(window.rootViewController, vc)
    }

    func testURLRequest() {
        let sut1 = URLRequest.createRequest(url: "http://www.foo.com/resource/test.json", httpMethod: "GET")
        XCTAssertEqual(sut1.url?.absoluteString, "http://www.foo.com/resource/test.json")
        XCTAssertEqual(sut1.httpMethod, "GET")

        let sut2 = URLRequest.createRequest(url: "http://www.foo.com/resource/test2.json",
                                            httpMethod: "POST",
                                            urlParams: ["a": "a1", "b": "b1"])
        XCTAssertTrue(["http://www.foo.com/resource/test2.json?a=a1&b=b1",
                       "http://www.foo.com/resource/test2.json?b=b1&a=a1"].contains(sut2.url!.absoluteString))
        XCTAssertEqual(sut2.httpMethod, "POST")
    }

    func testStringExtension() {
        XCTAssertEqual("test/of".appendingPathComponent("appending"), "test/of/appending")
        XCTAssertEqual("test/of".appendingPathExtension("appending"), "test/of.appending")
        XCTAssertEqual("Hello".leftPadding(toLength: 9, withPad: "x"), "xxxxHello")
        XCTAssertEqual("Hello".leftPadding(toLength: 10, withPad: "x"), "xxxxxHello")
        XCTAssertEqual("Hello".leftPadding(toLength: 4, withPad: "x"), "ello")
    }
}
