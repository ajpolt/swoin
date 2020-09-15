//
//  SingleDependencyCache.swift
//  Swoin
//
//  Created by Adam Polt on 9/11/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

class SingleDependencyCache: DependencyCache {
    var cache = [String: Any]()

    public func resolve<T>(entry: DependencyEntry<T>) -> T? {
        let cacheKey = "\(entry.key):\(entry.name ?? "")"

        if cache[cacheKey] == nil {
            cache[cacheKey] = entry.createDependency()
        }

        return cache[cacheKey] as? T
    }
}
