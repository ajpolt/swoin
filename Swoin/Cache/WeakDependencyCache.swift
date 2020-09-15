//
//  WeakDependencyCache.swift
//  Swoin
//
//  Created by Adam Polt on 9/11/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

class WeakDependencyCache: DependencyCache {
    private var cache = [String: WeakRef]()

    public func resolve<T>(entry: DependencyEntry<T>) -> T? {
        let cacheKey = "\(entry.key):\(entry.name ?? "")"

        if let dependency = cache[cacheKey]?.value as? T {
            return dependency
        } else {
            let value = entry.createDependency()
            cache[cacheKey] = WeakRef(value as AnyObject)
            return value
        }
    }

    private struct WeakRef {
        weak var value: AnyObject?

        init(_ value: AnyObject) {
            self.value = value
        }
    }
}
