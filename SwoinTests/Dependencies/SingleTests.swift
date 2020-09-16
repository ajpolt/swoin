//
//  SingleTests.swift
//  SwoinTests
//
//  Created by Adam Polt on 9/15/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

import Nimble
import Quick
@testable import Swoin

class SingleSpec: QuickSpec {
    override func spec() {
        describe("A single dependency") {
            it("is initialized with correct name and cache type") {
                let subject = single(named: "someName") { "12345" }
                
                expect(subject.cacheType).to(equal(CacheType.single))
                expect(subject.name).to(equal("someName"))
                expect(subject.factory()).to(equal("12345"))
            }
        }
    }
}
