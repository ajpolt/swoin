//
//  SingleDependencyCacheTests.swift
//  SwoinTests
//
//  Created by Adam Polt on 9/16/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

import Nimble
import Quick
@testable import Swoin

class SingleDependencyCacheSpec: QuickSpec {
    override func spec() {
        describe("A SingleDependencyCache") {
            var subject: SingleDependencyCache!
            
            beforeEach {
                subject = SingleDependencyCache()
            }
            
            context("on resolve") {
                it("calls factory only once") {
                    var count = 0
                    let entry = DependencyEntry(key: 123, named: "Whatever", cacheType: .single) { count += 1 }
                    
                    subject.resolve(entry: entry)
                    subject.resolve(entry: entry)
                    subject.resolve(entry: entry)
                    
                    expect(count).to(equal(1))
                }
            }
        }
    }
}
