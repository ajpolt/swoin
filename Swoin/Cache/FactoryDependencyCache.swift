//
//  FactoryDependencyCache.swift
//  Swoin
//
//  Created by Adam Polt on 9/11/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

class FactoryDependencyCache: DependencyCache {
    public func resolve<T>(entry: DependencyEntry<T>) -> T? {
        return entry.createDependency()
    }
}
