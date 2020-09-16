//
//  CacheHolderTests.swift
//  SwoinTests
//
//  Created by Adam Polt on 9/16/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

import Nimble
import Quick
@testable import Swoin

class CacheHolderSpec: QuickSpec {
    override func spec() {
        describe("a cache holder") {
            var subject: CacheHolder!
            
            beforeEach {
                subject = CacheHolder()
            }
            
            context("when get called with .factory") {
                it("returns a Factory cache") {
                    let cache = subject.getCache(type: .factory)
                    
                    expect(cache).to(beAnInstanceOf(FactoryDependencyCache.self))
                }
            }
            
            context("when get called with .single") {
                it("returns a Single cache") {
                    let cache = subject.getCache(type: .single)
                    
                    expect(cache).to(beAnInstanceOf(SingleDependencyCache.self))
                }
            }
            
            context("when get called with .weak") {
                it("returns a Weak cache") {
                    let cache = subject.getCache(type: .weak)
                    
                    expect(cache).to(beAnInstanceOf(WeakDependencyCache.self))
                }
            }
        }
    }
}
