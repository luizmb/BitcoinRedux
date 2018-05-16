@testable import CommonLibrary
import Foundation
import XCTest

class DataStructureTests: UnitTest {
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

    func testSyncableResult() {
        let neverLoaded1: SyncableResult<String> = .neverLoaded
        let neverLoaded2: SyncableResult<String> = .neverLoaded
        let loading1: SyncableResult<String> = .syncing(task: Cancelable(), oldValue: nil)
        let loading2: SyncableResult<String> = .syncing(task: Cancelable(), oldValue: nil)
        let loading3: SyncableResult<String> = .syncing(task: Cancelable(), oldValue: .success("A"))
        let loading4: SyncableResult<String> = .syncing(task: Cancelable(), oldValue: .error(AnyError()))
        let loadedA1: SyncableResult<String> = .loaded(.success("a"))
        let loadedA2: SyncableResult<String> = .loaded(.success("a"))
        let loadedB1: SyncableResult<String> = .loaded(.success("b"))
        let loadedB2: SyncableResult<String> = .loaded(.success("b"))
        let loadedError1: SyncableResult<String> = .loaded(.error(AnyError()))
        let loadedError2: SyncableResult<String> = .loaded(.error(AnyError()))

        XCTAssertTrue(neverLoaded1 == neverLoaded2)
        XCTAssertTrue(loading1 == loading2)
        XCTAssertTrue(loadedA1 == loadedA2)
        XCTAssertTrue(loadedB1 == loadedB2)
        XCTAssertTrue(loadedError1 == loadedError2)

        XCTAssertFalse(neverLoaded1 == loading1)
        XCTAssertFalse(neverLoaded1 == loading3)
        XCTAssertFalse(neverLoaded1 == loading4)
        XCTAssertFalse(neverLoaded1 == loadedA1)
        XCTAssertFalse(neverLoaded1 == loadedB1)
        XCTAssertFalse(neverLoaded1 == loadedError1)
        XCTAssertFalse(loading1 == loading3)
        XCTAssertFalse(loading1 == loading4)
        XCTAssertFalse(loading1 == loadedA1)
        XCTAssertFalse(loading1 == loadedB1)
        XCTAssertFalse(loading1 == loadedError1)
        XCTAssertFalse(loading3 == loading4)
        XCTAssertFalse(loading3 == loadedA1)
        XCTAssertFalse(loading3 == loadedB1)
        XCTAssertFalse(loading3 == loadedError1)
        XCTAssertFalse(loading4 == loadedA1)
        XCTAssertFalse(loading4 == loadedB1)
        XCTAssertFalse(loading4 == loadedError1)
        XCTAssertFalse(loadedA1 == loadedB1)
        XCTAssertFalse(loadedA1 == loadedError1)
        XCTAssertFalse(loadedB1 == loadedError1)
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
        let successfulInt1: Result<Int> = .success(1)
        let successfulInt2: Result<Int> = .success(2)
        let e = AnyError()
        let errorInt: Result<Int> = .error(e)
        XCTAssertEqual(successfulInt1.map(String.init), .success("1"))
        XCTAssertEqual(successfulInt2.map(String.init), .success("2"))
        XCTAssertEqual(errorInt.map(String.init), .error(e))
    }

    func testResultFlatMap() {
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
