//
//  MockModule.swift
//  SwoinTests
//
//  Created by Adam Polt on 9/16/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

@testable import Swoin

class MockModule: Module {
    var registerModuleCount = 0
    var registerDependencyCount = 0
    var bindCount = 0
    
    var findCount = 0
    var resolveCount = 0
    
    var findable = false
    var resolvable = false
    
    override func register(swoin: Swoin) {
        registerModuleCount += 1
    }
    
    override func register<T>(_ type: T.Type = T.self, named name: String? = nil, cacheType: CacheType, factory: @escaping () -> T) {
        registerDependencyCount += 1
        
        super.register(type, named: name, cacheType: cacheType, factory: factory)
    }
    
    override func bind<ExistingType, AdditionalType>(additionalType: AdditionalType.Type, to existingType: ExistingType.Type, named name: String?, converter: @escaping (ExistingType) -> AdditionalType = { existing in existing as! AdditionalType }) {
        bindCount += 1
        
        super.bind(additionalType: additionalType, to: existingType, named: name, converter: converter)
    }
    
    override func find<T>(_ type: T.Type = T.self, named name: String? = nil) -> DependencyEntry<T>? {
        findCount += 1
        
        return super.find(type, named: name)
    }
    
    override func resolve<T>(_ type: T.Type = T.self, named name: String? = nil) -> T {
        resolveCount += 1
        
        return super.resolve(type, named: name)
    }
}
