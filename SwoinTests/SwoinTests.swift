//
//  SwoinTests.swift
//  SwoinTests
//
//  Created by Adam Polt on 9/11/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

import Nimble
import Quick
@testable import Swoin

class SwoinSpec: QuickSpec {
    override func spec() {
        afterEach {
            stopSwoin()
        }
        
        describe("static func Swoin.start") {
            it("runs the given builder") {
                let module1 = MockModule()
                let module2 = MockModule()
                
                _ = Swoin.start {
                    module1
                    module2
                }
                
                expect(module1.registerModuleCount).to(equal(1))
                expect(module2.registerModuleCount).to(equal(1))
            }
        }
        
        describe("global func startSwoin") {
            it("sets the global Swoin instance") {
                let module1 = MockModule()
                let module2 = MockModule()
                
                let instance = startSwoin {
                    module1
                    module2
                    logger(Swoin.printLogger)
                }
                
                expect(Swoin.global).to(be(instance))
                expect(module1.registerModuleCount).to(equal(1))
                expect(module2.registerModuleCount).to(equal(1))
            }
            
            afterEach {
                stopSwoin()
            }
        }
        
        describe("global func stopSwoin") {
            context("when Swoin started") {
                beforeEach {
                    let module1 = MockModule()
                    let module2 = MockModule()
                    
                    startSwoin {
                        modules([module1, module2])
                        logger(Swoin.printLogger)
                    }
                }
                
                it("sets the global swoin instance to nil") {
                    stopSwoin()
                    expect(Swoin.global).to(beNil())
                }
            }
        }
        
        describe("a Swoin instance") {
            var subject: Swoin!
            
            beforeEach {
                subject = Swoin()
            }
            
            context("when load(module) is called") {
                var module: MockModule!
                beforeEach {
                    module = MockModule()
                    subject.load(module)
                }
                
                it("registers the given module") {
                    expect(subject.modules.count).to(equal(1))
                    expect(subject.modules.contains { $0 === module }).to(beTrue())
                }
                
                context("after unloading a module") {
                    beforeEach {
                        subject.unload(module)
                    }
                    
                    it("removes the given module from the list") {
                        expect(subject.modules.count).to(equal(0))
                    }
                }
            }
            
            context("when load([module]) is called") {
                var module1: MockModule!
                var module2: MockModule!
                
                beforeEach {
                    module1 = MockModule()
                    module2 = MockModule()
                    subject.load([module1, module2])
                }
                
                it("registers the given module") {
                    expect(subject.modules.count).to(equal(2))
                    expect(subject.modules.contains { $0 === module1 }).to(beTrue())
                    expect(subject.modules.contains { $0 === module2 }).to(beTrue())
                }
                
                context("after unloading the modules") {
                    beforeEach {
                        subject.unload([module1, module2])
                    }
                    
                    it("removes the given modules from the list") {
                        expect(subject.modules.count).to(equal(0))
                    }
                }
            }
            
            context("when a dependency of given type exists in a loaded module") {
                beforeEach {
                    let module: Module = Module(factory { Thing("123") })
                    subject.load(module)
                }
                
                it("gets the dependency from the module") {
                    expect(subject.get(Thing.self).value).to(equal("123"))
                }
            }
            
            context("when multiple modules have a dependency of a given type with same name") {
                beforeEach {
                    let module: Module = Module(factory { Thing("123") })
                    let otherModule: Module = Module(factory { Thing("456") })
                    subject.load(module)
                    subject.load(otherModule)
                }
                
                it("gets the last-loaded dependency") {
                    expect(subject.get(Thing.self).value).to(equal("456"))
                }
            }
            
            context("when multiple modules have a dependency of a given type with different names") {
                beforeEach {
                    let module: Module = Module(factory(named: "other") { Thing("123") })
                    let otherModule: Module = Module(factory(named: "other") { Thing("456") })
                    let thirdModule: Module = Module(factory { Thing("789") })
                    subject.load(module)
                    subject.load(otherModule)
                    subject.load(thirdModule)
                }
                
                it("gets the last-loaded dependency with requested name") {
                    expect(subject.get(Thing.self, named: "other").value).to(equal("456"))
                }
            }
        }
    }
}

//private protocol IntFetcher {
//    func fetchDataInt() -> Int
//}
//
//private protocol StringFetcher {
//    func fetchDataString() -> String
//}
//
//private class TestFetcher: IntFetcher, StringFetcher {
//    func fetchDataInt() -> Int {
//        return 12345
//    }
//
//    func fetchDataString() -> String {
//        return "12345"
//    }
//}
//
//private class CircularDependencyOne {
//    let dependencyTwo: CircularDependencyTwo
//
//    init(_ dependencyTwo: CircularDependencyTwo) {
//        self.dependencyTwo = dependencyTwo
//    }
//}
//
//private class CircularDependencyTwo {
//    var dependencyOne: CircularDependencyOne?
//}
//
//private class TestThing {}
//
//class SwoinSpec: XCTestCase {
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//
//        stopSwoin()
//        
//        let testModule = Module {
//            weak { TestThing() }
//                .bind(TestThing?.self)
//
//            weak { TestFetcher() }
//                .bind(IntFetcher.self)
//                .bind(StringFetcher.self)
//
//            single { CircularDependencyOne(get()) }
//                .then {
//                    $0.dependencyTwo.dependencyOne = $0
//                }
//
//            single { CircularDependencyTwo() }
//
//            single { UINavigationController() }
//        }
//
//        startSwoin {
//            testModule
//            logger(Swoin.printLogger)
//        }
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//
//        stopSwoin()
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testCircular() throws {
//        let subject1: CircularDependencyOne = get()
//        let subject2: CircularDependencyTwo = get()
//
//        XCTAssert(subject1.dependencyTwo === subject2)
//        XCTAssert(subject2.dependencyOne === subject1)
//    }
//
//    func testWeakness() throws {
//        var subject: TestThing? = get()
//        weak var secondSubject: TestThing? = get()
//
//        let areSame = (subject as AnyObject === secondSubject as AnyObject)
//
//        assert(areSame, "Should be same object")
//
//        subject = nil
//        assert(secondSubject == nil, "Should be nil")
//    }
//
//    func testBindsAreShared() throws {
//        let testFetcher: TestFetcher = get()
//        let intFetcher: IntFetcher = get()
//        let stringFetcher: StringFetcher = get()
//
//        assert(testFetcher === intFetcher as AnyObject, "Types should be shared")
//        assert(testFetcher === stringFetcher as AnyObject, "Types should be shared")
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//
//}
