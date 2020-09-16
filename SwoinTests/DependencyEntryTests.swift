//
//  DependencyEntryTests.swift
//  SwoinTests
//
//  Created by Adam Polt on 9/15/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

import Nimble
import Quick
@testable import Swoin

class DependencyEntrySpec: QuickSpec {
    var mockFactory: MockFactoryCreator!
    var subject: DependencyEntry<String>!
    
    override func spec() {
        beforeEach {
            self.mockFactory = MockFactoryCreator()
        }
        
        describe("A dependency entry") {
            let expectedValue = "12345"
            
            beforeEach {
                self.subject = DependencyEntry(key: 12345, named: nil, cacheType: .factory, factory: self.mockFactory.getFactory(for: expectedValue))
            }
            
            context("when create called") {
                var value: String!
                
                beforeEach {
                    value = self.subject.createDependency()
                }
                
                it("runs the specified factory closure") {
                    expect(value).to(be(expectedValue))
                    expect(self.mockFactory.factoryRunCount).to(equal(1))
                }
                
            }
        }
    }
}
