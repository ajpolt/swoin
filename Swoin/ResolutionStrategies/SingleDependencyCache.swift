//
//  SingleDependencyCache.swift
//  Swoin
//
//  Created by Adam Polt on 9/11/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

class SingleDependencyCache: DependencyCache {
    var cache = [String : Any]()
    
    public func resolve<T>(entry: DependencyEntry<T>) -> T? {
        let cacheKey = "\(entry.key):\(entry.name ?? "")"

        if cache[cacheKey] == nil {
            print("Initializing Single dependency for \(T.self) \(entry.name != nil ? "named \(entry.name!)" : "")")
            cache[cacheKey] = entry.createDependency()
        }

        print("Resolving Single dependency for \(T.self) \(entry.name != nil ? "named \(entry.name!)" : "")")

        return cache[cacheKey] as? T
    }
}
