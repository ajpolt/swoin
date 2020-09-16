//
//  MockDependency.swift
//  SwoinTests
//
//  Created by Adam Polt on 9/15/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

@testable import Swoin

class MockDependency: Dependency {
    var registerCount = 0
    var bindCount = 0
    
    var name: String?
    
    var cacheType: CacheType
    
    init(name: String? = nil, cacheType: CacheType = .factory) {
        self.name = name
        self.cacheType = cacheType
    }
    
    func register(_ module: Module) {
        registerCount += 1
    }
    
    func bind<NewType>(_ type: NewType.Type) -> Dependency {
        bindCount += 1
        return MockDependency(name: self.name, cacheType: self.cacheType)
    }
}
