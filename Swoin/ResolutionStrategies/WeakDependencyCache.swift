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
            print("Resolving Weak dependency for \(T.self) \(entry.name != nil ? "named \(entry.name!)" : "")")
            
            return dependency
        } else {
            print("Initializing Weak dependency for \(T.self) \(entry.name != nil ? "named \(entry.name!)" : "")")
            
            let value = entry.createDependency()
            
            cache[cacheKey] = WeakRef(value as AnyObject)
            
            print("Resolving Weak dependency for \(T.self) \(entry.name != nil ? "named \(entry.name!)" : "")")
            
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
