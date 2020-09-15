//
//  SwoinTests.swift
//  SwoinTests
//
//  Created by Adam Polt on 9/11/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

import XCTest
@testable import Swoin

private protocol IntFetcher {
    func fetchDataInt() -> Int
}

private protocol StringFetcher {
    func fetchDataString() -> String
}

private class TestFetcher: IntFetcher, StringFetcher {
    func fetchDataInt() -> Int {
        return 12345
    }

    func fetchDataString() -> String {
        return "12345"
    }
}

private class CircularDependencyOne {
    let dependencyTwo: CircularDependencyTwo

    init(_ dependencyTwo: CircularDependencyTwo) {
        self.dependencyTwo = dependencyTwo
    }
}

private class CircularDependencyTwo {
    var dependencyOne: CircularDependencyOne?
}

private class TestThing {}

class SwoinTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        let testModule = Module {
            weak { TestThing() }
                .bind(TestThing?.self)

            weak { TestFetcher() }
                .bind(IntFetcher.self)
                .bind(StringFetcher.self)

            single { CircularDependencyOne(get()) }
                .then {
                    $0.dependencyTwo.dependencyOne = $0
                }

            single { CircularDependencyTwo() }

            single { UINavigationController() }
        }

        startSwoin {
            testModule
            logger(Swoin.printLogger)
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.

        stopSwoin()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testCircular() throws {
        let subject1: CircularDependencyOne = get()
        let subject2: CircularDependencyTwo = get()

        XCTAssert(subject1.dependencyTwo === subject2)
        XCTAssert(subject2.dependencyOne === subject1)
    }

    func testWeakness() throws {
        var subject: TestThing? = get()
        weak var secondSubject: TestThing? = get()

        let areSame = (subject as AnyObject === secondSubject as AnyObject)

        assert(areSame, "Should be same object")

        subject = nil
        assert(secondSubject == nil, "Should be nil")
    }

    func testBindsAreShared() throws {
        let testFetcher: TestFetcher = get()
        let intFetcher: IntFetcher = get()
        let stringFetcher: StringFetcher = get()

        assert(testFetcher === intFetcher as AnyObject, "Types should be shared")
        assert(testFetcher === stringFetcher as AnyObject, "Types should be shared")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
