//
//  GetTests.swift
//  SwoinTests
//
//  Created by Adam Polt on 9/15/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

import Nimble
import Quick
@testable import Swoin

class GetSpec: QuickSpec {
    private var mockGlobalSwoin: MockSwoin!
    private let expectedValue = "12345"
    
    override func spec() {
        beforeEach {
            self.mockGlobalSwoin = MockSwoin(value: self.expectedValue)
            Swoin.global = self.mockGlobalSwoin
        }
        
        afterEach {
            self.mockGlobalSwoin = nil
        }
        
        describe("get") {
            context("without specifying a name or swoin instance") {
                it("calls get() from the global swoin instance") {
                    let stringValue: String = get()
                    
                    expect(stringValue).to(equal(self.expectedValue))
                    expect(self.mockGlobalSwoin.getCount(type: String.self, named: nil)).to(equal(1))
                }
            }
            
            context("when named but not specifying a swoin instance") {
                
                it("calls get(name) from the global swoin instance") {
                    let name = "someName"
                    let _: String = get(named: name)
                    
                    expect(self.mockGlobalSwoin.getCount(type: String.self, named: name)).to(equal(1))
                }
                
                it("returns expected value from the Swoin instance") {
                    let name = "someName"
                    let stringValue: String = get(named: name)
                    
                    expect(stringValue).to(equal(self.expectedValue))
                }
            }
            
            context("specifying a custom Swoin as a parameter") {
                var customSwoin: MockSwoin!
                let customExpectedValue = "56789"
                
                beforeEach {
                    customSwoin = MockSwoin(value: customExpectedValue)
                }
                
                context("without specifying a name") {
                    it("calls get() from the custom swoin instance") {
                        let _: String = get(swoin: customSwoin)
                        
                        expect(customSwoin.getCount(type: String.self)).to(equal(1))
                    }
                    it("returns expected value from the Swoin instance") {
                        let stringValue: String = get(swoin: customSwoin)
                        
                        expect(stringValue).to(equal(customExpectedValue))
                    }
                    it("does not make a call to the global swoin instance") {
                        let _: String = get(swoin: customSwoin)
                        
                        expect(self.mockGlobalSwoin.getCount(type: String.self)).to(equal(0))
                    }
                }
                
                context("when named") {
                    it("calls get(name) from the custom swoin instance") {
                        let name = "someName"
                        let _: String = get(named: name, swoin: customSwoin)
                        
                        expect(customSwoin.getCount(type: String.self, named: name)).to(equal(1))
                    }
                    it("returns expected value from the Swoin instance") {
                        let name = "someName"
                        let stringValue: String = get(named: name, swoin: customSwoin)
                        
                        expect(stringValue).to(equal(customExpectedValue))
                    }
                    it("does not make a call to the global swoin instance") {
                        let name = "someName"
                        let _: String = get(named: name, swoin: customSwoin)
                        
                        expect(self.mockGlobalSwoin.getCount(type: String.self, named: name)).to(equal(0))
                    }
                }
            }
        }
    }
}
