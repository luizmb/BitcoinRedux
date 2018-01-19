//
//  CocoaExTests.swift
//  N26Tests
//
//  Created by Luiz Rodrigo Martins Barbosa on 19.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import XCTest
import Foundation
@testable import N26

class AnotherCollectionReusableView: UICollectionReusableView { }
class AnotherTableViewCell: UITableViewCell { }
class AnotherView: UIView { }
class AnotherViewController: UIViewController { }

class CocoaExTests: XCTestCase {
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

    func testWindowHelpers() {
        let window = UIWindow.create()
        XCTAssertEqual(window.frame, UIScreen.main.bounds)

        let vc = AnotherViewController()
        window.setup(with: vc)
        XCTAssertTrue(window.isKeyWindow)
        XCTAssertEqual(window.rootViewController, vc)
    }
}
