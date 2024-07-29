import XCTest
import Quick
import Nimble

private enum BeforeEachType {
    case outerOne
    case outerTwo
    case innerOne
    case innerTwo
    case innerThree
    case noExamples
}

private var beforeEachOrder = [BeforeEachType]()

private enum ThrowingBeforeEachType: String, CustomStringConvertible {
    case outerOne
    case outerTwo
    case outerThree
    case justBeforeEach
    case inner
    case afterEach
    case afterEachInner

    var description: String { rawValue }
}

private var throwingBeforeEachOrder = [ThrowingBeforeEachType]()

private struct BeforeEachError: Error {}

private var isRunningFunctionalTests = false

@MainActor
private class MainActorClass {
    var field = 0
}

class FunctionalTests_BeforeEachAsyncSpec: AsyncSpec {
    override class func spec() {

        describe("beforeEach ordering") {
            beforeEach { beforeEachOrder.append(.outerOne) }
            beforeEach { beforeEachOrder.append(.outerTwo) }

            it("executes the outer beforeEach closures once [1]") {}
            it("executes the outer beforeEach closures a second time [2]") {}

            context("when there are nested beforeEach") {
                beforeEach { beforeEachOrder.append(.innerOne) }
                beforeEach { beforeEachOrder.append(.innerTwo) }
                beforeEach { beforeEachOrder.append(.innerThree) }

                it("executes the outer and inner beforeEach closures [3]") {}
            }

            context("when there are nested beforeEach without examples") {
                beforeEach { beforeEachOrder.append(.noExamples) }
            }
        }

        describe("throwing errors") {
            justBeforeEach { throwingBeforeEachOrder.append(.justBeforeEach) }
            beforeEach { throwingBeforeEachOrder.append(.outerOne) }

            beforeEach {
                throwingBeforeEachOrder.append(.outerTwo)
                if isRunningFunctionalTests {
                    throw BeforeEachError()
                }
            }

            beforeEach {
                throwingBeforeEachOrder.append(.outerThree)
            }

            afterEach { throwingBeforeEachOrder.append(.afterEach) }

            it("does not run tests") {
                if isRunningFunctionalTests {
                    fail("tests should not be run here")
                }
            }

            context("when nested") {
                beforeEach {
                    throwingBeforeEachOrder.append(.inner)
                }

                afterEach {
                    throwingBeforeEachOrder.append(.afterEachInner)
                }

                it("still does not run tests") {
                    if isRunningFunctionalTests {
                        fail("tests should not be run.")
                    }
                }
            }
        }

#if canImport(Darwin) && !SWIFT_PACKAGE
        describe("error handling when misusing ordering") {
            it("should throw an exception when including beforeEach in it block") {
                expect {
                    beforeEach { }
                    }.to(raiseException { (exception: NSException) in
                        expect(exception.name).to(equal(NSExceptionName.internalInconsistencyException))
                        expect(exception.reason).to(equal("'beforeEach' cannot be used inside 'it', 'beforeEach' may only be used inside 'context' or 'describe'."))
                        })
            }
        }
#endif
        describe("main isolation") {
            beforeEachMain {
                _ = MainActorClass()
                MainActor.assertIsolated()
                throwingBeforeEachOrder.append(.outerOne)
            }
            
            beforeEachMain { _ in
                _ = MainActorClass()
                MainActor.assertIsolated()
                throwingBeforeEachOrder.append(.outerTwo)
            }
            
            afterEachMain {
                throwingBeforeEachOrder.append(.afterEach)
            }
            
            afterEachMain { _ in
                throwingBeforeEachOrder.append(.afterEach)
            }
            
            itMain("does not run tests") {
                if isRunningFunctionalTests {
                    fail("tests should not be run.")
                }
            }
        }
    }
}

private var skippingBeforeEachOrder = [ThrowingBeforeEachType]()

class FunctionalTests_BeforeEachSkippingAsyncSpec: AsyncSpec {
    override class func spec() {
        describe("skipping tests") {
            beforeEach {
                throw XCTSkip("this test is intentionally skipped")
            }

            afterEach {
                skippingBeforeEachOrder.append(.afterEach)
            }

            it("skips this test") {
                skippingBeforeEachOrder.append(.inner)
            }
        }
        
        describe("skipping from MainActor") {
            beforeEachMain {
                throw XCTSkip("this test is intentionally skipped")
            }
            
            afterEach {
                skippingBeforeEachOrder.append(.afterEach)
            }

            it("skips this test") {
                skippingBeforeEachOrder.append(.inner)
            }
        }
    }
}

private var stoppingBeforeEachOrder = [ThrowingBeforeEachType]()

class FunctionalTests_BeforeEachStoppingAsyncSpec: AsyncSpec {
    override class func spec() {
        describe("stopping tests") {
            context("silently stopping") {
                beforeEach {
                    if isRunningFunctionalTests {
                        throw StopTest.silently
                    }
                }

                afterEach {
                    stoppingBeforeEachOrder.append(.outerOne)
                }

                it("supports silently stopping tests") {
                    stoppingBeforeEachOrder.append(.inner)
                }
            }

            context("stopping tests with expected tests") {
                beforeEach {
                    if isRunningFunctionalTests {
                        throw StopTest("some error")
                    }
                }

                afterEach {
                    stoppingBeforeEachOrder.append(.outerTwo)
                }

                it("supports stopping tests with an error message") {
                    stoppingBeforeEachOrder.append(.inner)
                }
            }
        }
    }
}

final class BeforeEachAsyncTests: XCTestCase, XCTestCaseProvider {
    static var allTests: [(String, (BeforeEachAsyncTests) -> () throws -> Void)] {
        return [
            ("testBeforeEachIsExecutedInTheCorrectOrder", testBeforeEachIsExecutedInTheCorrectOrder),
            ("testBeforeEachWhenThrowingStopsRunningTestsButDoesCallAfterEachs", testBeforeEachWhenThrowingStopsRunningTestsButDoesCallAfterEachs),
            ("testSkippingExamplesAreCorrectlyReported", testSkippingExamplesAreCorrectlyReported),
            ("testStoppingExamplesAreCorrectlyReported", testStoppingExamplesAreCorrectlyReported),
        ]
    }

    override func setUp() {
        isRunningFunctionalTests = true
    }

    override func tearDown() {
        isRunningFunctionalTests = false
    }

    func testBeforeEachIsExecutedInTheCorrectOrder() {
        beforeEachOrder = []

        qck_runSpec(FunctionalTests_BeforeEachAsyncSpec.self)
        let expectedOrder: [BeforeEachType] = [
            // [1] The outer beforeEach closures are executed from top to bottom.
            .outerOne, .outerTwo,
            // [2] The outer beforeEach closures are executed from top to bottom.
            .outerOne, .outerTwo,
            // [3] The outer beforeEach closures are executed from top to bottom,
            //     then the inner beforeEach closures are executed from top to bottom.
            .outerOne, .outerTwo, .innerOne, .innerTwo, .innerThree,
        ]
        XCTAssertEqual(beforeEachOrder, expectedOrder)
    }

    func testBeforeEachWhenThrowingStopsRunningTestsButDoesCallAfterEachs() {
        throwingBeforeEachOrder = []

        qck_runSpec(FunctionalTests_BeforeEachAsyncSpec.self)

        let expectedOrder: [ThrowingBeforeEachType] = [
            // It runs the first beforeEach, which doesn't throw.
            .outerOne,
            // It runs the second beforeEach, which throws after recording that it ran
            .outerTwo,
            // It doesn't run the third beforeEach.
            // It doesn't run the test.
            // It does run the teardowns.
            .afterEach,
            // and then repeat because there are two tests.
            .outerOne,
            .outerTwo,
            .afterEach,
            // Main Actor tests
            .outerOne, .outerTwo, .afterEach, .afterEach
        ]

        XCTAssertEqual(
            throwingBeforeEachOrder,
            expectedOrder
        )
    }

    func testSkippingExamplesAreCorrectlyReported() {
        skippingBeforeEachOrder = []

        let result = qck_runSpec(FunctionalTests_BeforeEachSkippingAsyncSpec.self)!
        XCTAssertTrue(result.hasSucceeded)
        XCTAssertEqual(result.executionCount, 2)
        XCTAssertEqual(result.skipCount, 2)
        XCTAssertEqual(result.totalFailureCount, 0)

        XCTAssertEqual(
            skippingBeforeEachOrder,
            [.afterEach, .afterEach] // it still runs the afterEachs
        )
    }

    func testStoppingExamplesAreCorrectlyReported() {
        stoppingBeforeEachOrder = []

        let result = qck_runSpec(FunctionalTests_BeforeEachStoppingAsyncSpec.self)!
        XCTAssertFalse(result.hasSucceeded)
        XCTAssertEqual(result.executionCount, 2)
        XCTAssertEqual(result.failureCount, 1)
        XCTAssertEqual(result.unexpectedExceptionCount, 0)
        XCTAssertEqual(result.totalFailureCount, 1)

        XCTAssertEqual(
            stoppingBeforeEachOrder,
            [.outerOne, .outerTwo]
        )
    }
}
