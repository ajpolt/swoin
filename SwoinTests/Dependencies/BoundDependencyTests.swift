//
//  BoundDependencyTests.swift
//  SwoinTests
//
//  Created by Adam Polt on 9/16/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

import Nimble
import Quick
@testable import Swoin

class BoundDependencySpec: QuickSpec {
    override func spec() {
        describe("A bound dependency") {
            var subject: BoundDependency<OtherThing, Thing>!
            var testThing: OtherThing!
            
            beforeEach {
                testThing = OtherThing("12345")
                
                let wrappedDependency = ResolvableDependency<OtherThing>(named: "someName", cacheType: .factory) { testThing }
                
                subject = BoundDependency(wrappedDependency: wrappedDependency, wrappedFactory: wrappedDependency.factory) { $0 as Thing }
            }
            
            context("when registered") {
                var mockModule: MockModule!
                beforeEach {
                    mockModule = MockModule()
                    subject.register(mockModule)
                }
                
                it("registers itself with the given module") {
                    expect(mockModule.registerDependencyCount).to(be(1))
                }
            }
            
            context("when bound with default converter") {
                var boundDependency: BoundDependency<OtherThing, DifferentThing>!
                beforeEach {
                    boundDependency = subject.bind(DifferentThing.self)
                }
                
                it("correctly wraps the original cache type") {
                    expect(boundDependency.cacheType).to(equal(CacheType.factory))
                }
                
                it("correctly wraps the original name") {
                    expect(boundDependency.name).to(equal("someName"))
                }
                
                it("uses the original factory") {
                    let value = boundDependency.wrappedFactory()
                    expect(value).to(be(testThing))
                }
                
                it("uses the default forced cast converter") {
                    let value = boundDependency.converter(boundDependency.wrappedFactory())
                    expect(value).to(be(testThing))
                }
            }
            
            context("when bound with a custom converter") {
                var boundDependency: BoundDependency<OtherThing, ThingHolder>!
                var converter: ((Thing) -> ThingHolder)!
                
                beforeEach {
                    converter = {
                        return ThingHolder($0)
                    }
                    boundDependency = subject.bind(ThingHolder.self, converter)
                }
                
                it("correctly wraps the original cache type") {
                    expect(boundDependency.cacheType).to(equal(CacheType.factory))
                }
                
                it("correctly wraps the original name") {
                    expect(boundDependency.name).to(equal("someName"))
                }
                
                it("uses the original factory") {
                    let value = boundDependency.wrappedFactory()
                    expect(value).to(be(testThing))
                }
                
                it("uses the given converter") {
                    let value = boundDependency.converter(boundDependency.wrappedFactory())
                    expect(value.thing).to(be(testThing))
                }
            }
            
            context("when then is used") {
                var thenDependency: ResolvableDependency<OtherThing>!
                
                beforeEach {
                    thenDependency = subject.then { $0.value = "9000" }
                }
                
                it("does not alter the original factory") {
                    expect(subject.wrappedFactory().value).to(equal("12345"))
                }
                
                it("returned dependency applies the given closure") {
                    expect(thenDependency.factory().value).to(equal("9000"))
                }
            }
        }
    }
}
