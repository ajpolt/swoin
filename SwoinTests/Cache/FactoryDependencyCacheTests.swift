//
//  FactoryDependencyCacheTests.swift
//  SwoinTests
//
//  Created by Adam Polt on 9/16/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

import Nimble
import Quick
@testable import Swoin

class FactoryDependencyCacheSpec: QuickSpec {
    override func spec() {
        describe("A FactoryDependencyCache") {
            var subject: FactoryDependencyCache!
            
            beforeEach {
                subject = FactoryDependencyCache()
            }
            
            context("on resolve") {
                it("calls factory each time") {
                    var count = 0
                    let entry = DependencyEntry(key: 123, named: "Whatever", cacheType: .factory) { count += 1 }
                    subject.resolve(entry: entry)
                    subject.resolve(entry: entry)
                    
                    expect(count).to(equal(2))
                }
            }
        }
    }
}
