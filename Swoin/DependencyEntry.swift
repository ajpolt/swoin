//
//  DependencyEntry.swift
//  Swoin
//
//  Created by Adam Polt on 9/11/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

public class DependencyEntry<T> {
    public var key: Int
    public var name: String?
    public var cacheType: CacheType
    public var factory: () -> T
    
    init(key: Int, named name: String?, cacheType: CacheType, factory: @escaping () -> T) {
        self.key = key
        self.name = name
        self.cacheType = cacheType
        self.factory = factory
    }
    
    func createDependency() -> T {
        return factory()
    }
}
