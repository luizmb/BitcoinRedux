//
//  ThemeTests.swift
//  N26Tests
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import XCTest
import Foundation
@testable import N26
@testable import CommonLibrary

class ThemeTests: UnitTest {
    func testNamedColors() {
        XCTAssertEqual(UIColor.of(.cellBackground), UIColor.Named.cellBackground.color)
        XCTAssertEqual(UIColor.of(.cellHighlightText), UIColor.Named.cellHighlightText.color)
        XCTAssertEqual(UIColor.of(.cellText), UIColor.Named.cellText.color)
        XCTAssertEqual(UIColor.of(.chromeBackground), UIColor.Named.chromeBackground.color)
        XCTAssertEqual(UIColor.of(.chromeText), UIColor.Named.chromeText.color)
        XCTAssertEqual(UIColor.of(.listBackground), UIColor.Named.listBackground.color)
        XCTAssertEqual(UIColor.of(.listSeparator), UIColor.Named.listSeparator.color)
    }

    func testApplyTheme() {
        Theme.apply()
        let navigationBarAppearance = UINavigationBar.appearance()

        XCTAssertEqual(navigationBarAppearance.titleTextAttributes?.count, 1)
        XCTAssertTrue((navigationBarAppearance.titleTextAttributes?.keys.contains(NSAttributedStringKey.foregroundColor))!)
        XCTAssertEqual(navigationBarAppearance.largeTitleTextAttributes?.count, 1)
        XCTAssertTrue((navigationBarAppearance.largeTitleTextAttributes?.keys.contains(NSAttributedStringKey.foregroundColor))!)
        XCTAssertFalse(navigationBarAppearance.isTranslucent)
        XCTAssertTrue(navigationBarAppearance.prefersLargeTitles)
    }
}
