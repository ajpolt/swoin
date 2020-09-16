//
//  WeakDependencyCacheTests.swift
//  SwoinTests
//
//  Created by Adam Polt on 9/16/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

import Nimble
import Quick
@testable import Swoin

class WeakDependencyCacheSpec: QuickSpec {
    override func spec() {
        describe("A WeakDependencyCache") {
            var subject: WeakDependencyCache!
            
            beforeEach {
                subject = WeakDependencyCache()
            }
            
            context("on resolve") {
                it("calls factory while no strong reference exists") {
                    var count = 0
                    
                    let entry = DependencyEntry<Thing>(key: 123, named: "Whatever", cacheType: .weak) {
                        count += 1
                        return Thing("12345")
                    }
                    
                    _ = subject.resolve(entry: entry)
                    _ = subject.resolve(entry: entry)
                    _ = subject.resolve(entry: entry)
                    
                    expect(count).to(equal(3))
                }
                
                it("does not call factory while strong reference exists") {
                    var count = 0
                    let entry = DependencyEntry<Thing>(key: 123, named: "Whatever", cacheType: .weak) {
                        count += 1
                        return Thing("\(count)")
                    }
                    
                    var value = subject.resolve(entry: entry)
                    _ = subject.resolve(entry: entry)
                    _ = subject.resolve(entry: entry)
                    
                    expect(value?.value).to(equal("1"))
                    
                    value = nil
                    
                    value = subject.resolve(entry: entry)
                    _ = subject.resolve(entry: entry)
                    
                    expect(value?.value).to(equal("2"))
                }
            }
        }
    }
}
