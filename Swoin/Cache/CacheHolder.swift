//
//  CacheHolder.swift
//  Swoin
//
//  Created by Adam Polt on 9/11/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

struct CacheHolder {
    private lazy var single = SingleDependencyCache()
    private lazy var factory = FactoryDependencyCache()
    private lazy var weak = WeakDependencyCache()

    public mutating func getCache(type: CacheType) -> DependencyCache {
        switch type {
        case .single:
            return self.single
        case .factory:
            return self.factory
        case .weak:
            return self.weak
        }
    }
}
