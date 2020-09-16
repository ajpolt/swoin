//
//  InjectTests.swift
//  SwoinTests
//
//  Created by Adam Polt on 9/15/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

import Nimble
import Quick
@testable import Swoin

fileprivate var customSwoin: MockSwoin!

class InjectSpec: QuickSpec {
    private var mockGlobalSwoin: MockSwoin!
    private let expectedValue = "12345"
    private var customExpectedValue = "56789"
    
    private class InjectedClass {
        @Inject var injectedString: String
    }

    private class InjectedClassWithName {
        static let depName = "someName"
        @Inject(named: depName) var injectedString: String
    }

    private class InjectedClassWithCustomSwoin {
        @Inject(swoin: customSwoin) var injectedString: String
    }

    private class InjectedClassWithNameAndCustomSwoin {
        static let depName = "someOtherName"
        @Inject(named: depName, swoin: customSwoin) var injectedString: String
    }
    
    override func spec() {
        beforeEach {
            self.mockGlobalSwoin = MockSwoin(value: self.expectedValue)
            Swoin.global = self.mockGlobalSwoin
        }
        
        afterEach {
            self.mockGlobalSwoin = nil
        }
            
        describe("an @injected member variable") {
            context("without specifying a name or swoin instance") {
                var injectedClass: InjectedClass!
                
                beforeEach {
                    injectedClass = InjectedClass()
                }
                
                it("calls get() from the global swoin instance") {
                    let _ = injectedClass.injectedString
                    
                    expect(self.mockGlobalSwoin.getCount(type: String.self, named: nil)).to(equal(1))
                }
                
                it("returns expected value from the global Swoin instance") {
                    let stringValue = injectedClass.injectedString
                    
                    expect(stringValue).to(equal(self.expectedValue))
                }
            }
            
            context("when named but not specifying a swoin instance") {
                var injectedClassWithName: InjectedClassWithName!
                
                beforeEach {
                    injectedClassWithName = InjectedClassWithName()
                }
                
                it("calls get(name) from the global swoin instance") {
                    let _ = injectedClassWithName.injectedString
                    
                    expect(self.mockGlobalSwoin.getCount(type: String.self, named: InjectedClassWithName.depName)).to(equal(1))
                }
                
                it("returns expected value from the global Swoin instance") {
                    let stringValue: String = injectedClassWithName.injectedString
                    
                    expect(stringValue).to(equal(self.expectedValue))
                }
            }
            
            context("when specifying a swoin instance") {
                beforeEach {
                    customSwoin = MockSwoin(value: self.customExpectedValue)
                }
                
                context("without specifying a name") {
                    var injectedClass: InjectedClassWithCustomSwoin!
                    
                    beforeEach {
                        injectedClass = InjectedClassWithCustomSwoin()
                    }
                    
                    it("calls get() from the custom swoin instance") {
                        let _ = injectedClass.injectedString
                        
                        expect(customSwoin.getCount(type: String.self, named: nil)).to(equal(1))
                    }
                    
                    it("returns expected value from the Swoin instance") {
                        let stringValue = injectedClass.injectedString
                        
                        expect(stringValue).to(equal(self.customExpectedValue))
                    }
                }
                
                context("when named") {
                    var injectedClassWithName: InjectedClassWithNameAndCustomSwoin!
                    
                    beforeEach {
                        injectedClassWithName = InjectedClassWithNameAndCustomSwoin()
                    }
                    
                    it("calls get(name) from the custom swoin instance") {
                        let _ = injectedClassWithName.injectedString
                        
                        expect(customSwoin.getCount(type: String.self, named: InjectedClassWithNameAndCustomSwoin.depName)).to(equal(1))
                    }
                    
                    it("returns expected value from the Swoin instance") {
                        let stringValue: String = injectedClassWithName.injectedString
                        
                        expect(stringValue).to(equal(self.customExpectedValue))
                    }
                }
            }
        }
    }
}
