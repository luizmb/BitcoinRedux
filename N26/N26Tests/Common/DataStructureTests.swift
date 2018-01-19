//
//  DataStructureTests.swift
//  N26Tests
//
//  Created by Luiz Rodrigo Martins Barbosa on 19.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import XCTest
import Foundation
@testable import N26

class DataStructureTests: XCTestCase {
    func testAtomic() {
        let array = Atomic<[String]>([])
        XCTAssertTrue(array.atomicProperty.isEmpty)

        array.mutate { s in s.append("a") }
        XCTAssertEqual(array.atomicProperty.count, 1)
        XCTAssertEqual(array.atomicProperty, ["a"])

        array.mutate { s in s.append("b") }
        XCTAssertEqual(array.atomicProperty.count, 2)
        XCTAssertEqual(array.atomicProperty, ["a", "b"])
    }

    func testCancelableAsync() {
        struct Cancelable: CancelableTask { func cancel() { } }
        let notLoaded1: CancelableAsync<String> = .notLoaded
        let notLoaded2: CancelableAsync<String> = .notLoaded
        let loading1: CancelableAsync<String> = .loading(Cancelable())
        let loading2: CancelableAsync<String> = .loading(Cancelable())
        let loadedA1: CancelableAsync<String> = .loaded("a")
        let loadedA2: CancelableAsync<String> = .loaded("a")
        let loadedB1: CancelableAsync<String> = .loaded("b")
        let loadedB2: CancelableAsync<String> = .loaded("b")

        XCTAssertTrue(notLoaded1 == notLoaded2)
        XCTAssertTrue(loading1 == loading2)
        XCTAssertTrue(loadedA1 == loadedA2)
        XCTAssertTrue(loadedB1 == loadedB2)

        XCTAssertFalse(notLoaded1 == loading1)
        XCTAssertFalse(notLoaded1 == loadedA1)
        XCTAssertFalse(notLoaded1 == loadedB1)
        XCTAssertFalse(loading1 == loadedA1)
        XCTAssertFalse(loading1 == loadedB1)
        XCTAssertFalse(loadedA1 == loadedB1)
    }

    func testDisposable() {
        let shouldDispose: XCTestExpectation = expectation(description: "Disposed")
        var count = 0
        func scoped() {
            XCTAssertEqual(count, 0)
            let disposables = Disposable {
                count += 1
                shouldDispose.fulfill()
            }
            let anotherPointer = disposables
            _ = anotherPointer
            XCTAssertEqual(count, 0)
        }
        XCTAssertEqual(count, 0)
        scoped()
        wait(for: [shouldDispose], timeout: 1)
        XCTAssertEqual(count, 1)
    }

    func testDisposableBagToNil() {
        let shouldDispose: XCTestExpectation = expectation(description: "Disposed")
        var count = 0

        var bag: [Any]? = []
        Disposable {
            count += 1
            shouldDispose.fulfill()
        }.addDisposableTo(&bag!)

        XCTAssertEqual(bag!.count, 1)
        XCTAssertEqual(count, 0)

        bag = nil
        wait(for: [shouldDispose], timeout: 1)
        XCTAssertEqual(count, 1)
    }

    func testDisposableBagToEmpty() {
        let shouldDispose: XCTestExpectation = expectation(description: "Disposed")
        var count = 0

        var bag: [Any] = []
        Disposable {
            count += 1
            shouldDispose.fulfill()
        }.addDisposableTo(&bag)

        XCTAssertEqual(bag.count, 1)
        XCTAssertEqual(count, 0)

        bag.removeAll()
        wait(for: [shouldDispose], timeout: 1)
        XCTAssertEqual(count, 1)
    }

    func testResultMap() {
        class AnyError: Error { }
        let successfulInt1: Result<Int> = .success(1)
        let successfulInt2: Result<Int> = .success(2)
        let e = AnyError()
        let errorInt: Result<Int> = .error(e)
        XCTAssertEqual(successfulInt1.map(String.init), .success("1"))
        XCTAssertEqual(successfulInt2.map(String.init), .success("2"))
        XCTAssertEqual(errorInt.map(String.init), .error(e))
    }

    func testResultFlatMap() {
        class AnyError: Error { }
        let successfulInt1: Result<Int> = .success(1)
        let successfulInt2: Result<Int> = .success(2)
        let e = AnyError()
        let errorInt: Result<Int> = .error(e)

        func successfulFunc(_ input: Int) -> Result<String> {
            return .success(String(input))
        }

        func errorFunc(_ input: Int) -> Result<String> {
            return .error(e)
        }

        XCTAssertEqual(successfulInt1.flatMap(successfulFunc), .success("1"))
        XCTAssertEqual(successfulInt2.flatMap(successfulFunc), .success("2"))
        XCTAssertEqual(errorInt.flatMap(successfulFunc), .error(e))

        XCTAssertEqual(successfulInt1.flatMap(errorFunc), .error(e))
        XCTAssertEqual(successfulInt2.flatMap(errorFunc), .error(e))
        XCTAssertEqual(errorInt.flatMap(errorFunc), .error(e))
    }
}

