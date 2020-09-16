//
//  ModuleTests.swift
//  SwoinTests
//
//  Created by Adam Polt on 9/15/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

import Nimble
import Quick
@testable import Swoin

class ModuleSpec: QuickSpec {
    override func spec() {
        var subject: Module!
        
        describe("a module") {
            var dependency1: MockDependency!
            var dependency2: MockDependency!
            
            beforeEach {
                dependency1 = MockDependency()
                dependency2 = MockDependency()
                
                subject = Module {
                    dependency1!
                    dependency2!
                }
            }
            
            context("after init with builder") {
                it("registers all dependencies") {
                    expect(dependency1.registerCount).to(be(1))
                    expect(dependency2.registerCount).to(be(1))
                }
            }
            
            context("after init with single dependency constructor") {
                it("registers dependency") {
                    let dependency = MockDependency()
                    subject = Module(dependency)
                    
                    expect(dependency.registerCount).to(be(1))
                }
            }
            
            context("when registering with a Swoin container") {
                it("is loaded") {
                    let container = MockSwoin()
                    subject.register(swoin: container)
                    
                    expect(container.loadCount).to(be(1))
                }
            }
            
            context("before registering a given type") {
                it("find returns nil") {
                    let value = subject.find(Thing.self)
                    expect(value).to(beNil())
                }
            }
            
            context("after registering a no-name dependency with type Single") {
                beforeEach {
                    subject.register(Thing.self, named: nil, cacheType: .single, factory: { Thing("123") })
                }
                
                it("finds an entry for that Type") {
                    let entry = subject.find(Thing.self)
                    
                    expect(entry).toNot(beNil())
                    expect(entry?.cacheType).to(equal(.single))
                }
                
                it("resolves the expected type") {
                    let value = subject.resolve(Thing.self)
                    
                    expect(value).toNot(beNil())
                    expect(value.value).to(equal("123"))
                }
                
                weak var firstWeakRetrievedValue: Thing?
                weak var secondWeakRetrievedValue: Thing?
                it("holds a strong reference") {
                    firstWeakRetrievedValue = subject.resolve(Thing.self)
                    secondWeakRetrievedValue = subject.resolve(Thing.self)
                    
                    expect(firstWeakRetrievedValue).toNot(beNil())
                    expect(firstWeakRetrievedValue).to(be(secondWeakRetrievedValue))
                }
            }
            
            context("after registering an additional named dependency with type Single") {
                beforeEach {
                    subject.register(Thing.self, named: nil, cacheType: .single, factory: { Thing("123") })
                    subject.register(Thing.self, named: "someName", cacheType: .single, factory: { Thing("456") })
                }
                
                it("finds an entry for that Type") {
                    let entry = subject.find(Thing.self, named: "someName")
                    
                    expect(entry).toNot(beNil())
                    expect(entry?.cacheType).to(equal(.single))
                }
                
                it("resolves the expected type") {
                    let value = subject.resolve(Thing.self, named: "someName")
                    
                    expect(value).toNot(beNil())
                    expect(value.value).to(equal("456"))
                }
                
                weak var firstWeakRetrievedValue: Thing?
                weak var secondWeakRetrievedValue: Thing?
                it("holds a strong reference") {
                    firstWeakRetrievedValue = subject.resolve(Thing.self, named: "someName")
                    secondWeakRetrievedValue = subject.resolve(Thing.self, named: "someName")
                    
                    expect(firstWeakRetrievedValue).toNot(beNil())
                    expect(firstWeakRetrievedValue).to(be(secondWeakRetrievedValue))
                }
            }
            
            context("after registering a no-name dependency with type Weak") {
                beforeEach {
                    subject.register(Thing.self, named: nil, cacheType: .weak, factory: { Thing("123") })
                }
                
                it("finds an entry for that Type") {
                    let entry = subject.find(Thing.self)
                    
                    expect(entry).toNot(beNil())
                    expect(entry?.cacheType).to(equal(.weak))
                }
                
                it("resolves the expected type") {
                    let value = subject.resolve(Thing.self)
                    
                    expect(value).toNot(beNil())
                    expect(value.value).to(be("123"))
                }
                
                weak var weakRetrievedValue: Thing?
                it("holds a weak reference") {
                    weakRetrievedValue = subject.resolve(Thing.self)
                    
                    expect(weakRetrievedValue).to(beNil())
                }
            }
            
            context("after registering an additional named dependency with type Weak") {
                beforeEach {
                    subject.register(Thing.self, named: nil, cacheType: .weak, factory: { Thing("123") })
                    subject.register(Thing.self, named: "someName", cacheType: .weak, factory: { Thing("456") })
                }
                
                it("finds an entry for that Type") {
                    let entry = subject.find(Thing.self, named: "someName")
                    
                    expect(entry).toNot(beNil())
                    expect(entry?.cacheType).to(equal(.weak))
                }
                
                it("resolves the expected type") {
                    let value = subject.resolve(Thing.self, named: "someName")
                    
                    expect(value).toNot(beNil())
                    expect(value.value).to(equal("456"))
                }
                
                weak var weakRetrievedValue: Thing?
                it("holds a strong reference") {
                    weakRetrievedValue = subject.resolve(Thing.self, named: "someName")
                    
                    expect(weakRetrievedValue).to(beNil())
                }
            }
            
            context("after registering a no-name dependency with type Factory") {
                beforeEach {
                    subject.register(Thing.self, named: nil, cacheType: .factory, factory: { Thing("123") })
                }
                
                it("finds an entry for that Type") {
                    let entry = subject.find(Thing.self)
                    
                    expect(entry).toNot(beNil())
                    expect(entry?.cacheType).to(equal(.factory))
                }
                
                it("resolves the expected type") {
                    let value = subject.resolve(Thing.self)
                    
                    expect(value).toNot(beNil())
                    expect(value.value).to(equal("123"))
                }
                
                var firstRetrievedValue: Thing!
                var secondRetrievedValue: Thing!
                it("always returns a new object") {
                    firstRetrievedValue = subject.resolve(Thing.self)
                    secondRetrievedValue = subject.resolve(Thing.self)
                    
                    expect(firstRetrievedValue).toNot(be(secondRetrievedValue))
                }
            }
            
            context("after registering an additional named dependency with type Factory") {
                beforeEach {
                    subject.register(Thing.self, named: nil, cacheType: .factory, factory: { Thing("123") })
                    subject.register(Thing.self, named: "someName", cacheType: .factory, factory: { Thing("456") })
                }
                
                it("finds an entry for that Type") {
                    let entry = subject.find(Thing.self, named: "someName")
                    
                    expect(entry).toNot(beNil())
                    expect(entry?.cacheType).to(equal(.factory))
                }
                
                it("resolves the expected type") {
                    let value = subject.resolve(Thing.self, named: "someName")
                    
                    expect(value.value).to(equal("456"))
                }
                
                var firstRetrievedValue: Thing!
                var secondRetrievedValue: Thing!
                it("always returns a new object") {
                    firstRetrievedValue = subject.resolve(Thing.self, named: "someName")
                    secondRetrievedValue = subject.resolve(Thing.self, named: "someName")
                    
                    expect(firstRetrievedValue).toNot(be(secondRetrievedValue))
                }
            }
            
            context("after binding a second type to a registered type") {
                beforeEach {
                    subject.register(OtherThing.self, cacheType: .factory, factory: { OtherThing("123") })
                    
                    subject.bind(additionalType: Thing.self, to: OtherThing.self, named: nil)
                }
                
                it("finds an entry for the original Type") {
                    let entry = subject.find(OtherThing.self)
                    
                    expect(entry).toNot(beNil())
                    expect(entry?.cacheType).to(equal(.factory))
                }
                
                it("finds an entry for the bound Type") {
                    let entry = subject.find(Thing.self)
                    
                    expect(entry).toNot(beNil())
                    expect(entry?.cacheType).to(equal(.factory))
                }
                
                it("resolves the expected type") {
                    let value = subject.resolve(Thing.self)
                    expect(value.value).to(equal("123"))
                }
            }
            
            context("after binding a second type to a registered type with a converter") {
                beforeEach {
                    subject.register(Thing.self, cacheType: .single, factory: { Thing("123") })
                    
                    subject.bind(additionalType: ThingHolder.self, to: Thing.self, named: nil) {
                        ThingHolder($0)
                    }
                }
                
                it("finds an entry for the original Type") {
                    let entry = subject.find(Thing.self)
                    
                    expect(entry).toNot(beNil())
                    expect(entry?.cacheType).to(equal(.single))
                }
                
                it("finds an entry for the new Type") {
                    let entry = subject.find(ThingHolder.self)
                    
                    expect(entry).toNot(beNil())
                    expect(entry?.cacheType).to(equal(.single))
                }
                
                it("resolves the expected type using the closure") {
                    let thing = subject.resolve(Thing.self)
                    let value = subject.resolve(ThingHolder.self)
                    
                    expect(value).toNot(beNil())
                    expect(value.thing).to(be(thing))
                }
                
                context("after binding again") {
                    var thingHolder: ThingHolder!
                    
                    beforeEach {
                        thingHolder = ThingHolder(subject.resolve())
                        
                        subject.bind(additionalType: ThingHolder.self, to: Thing.self, named: nil) { _ in
                            return thingHolder
                        }
                    }
                    
                    it("overwrites the entry") {
                        let value: ThingHolder = subject.resolve()
                        expect(value).to(be(thingHolder))
                    }
                }
            }
        }
    }
}
