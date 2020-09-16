//
//  Module.swift
//  Swoin
//
//  Created by Adam Polt on 9/11/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

public class Module: SwoinParameter {
    private var dependencies = [Int: [String?: Any]]()

    private var cacheHolder = CacheHolder()

    init() {}

    public convenience init(@ModuleBuilder builder: () -> [Dependency]) {
        self.init()

        let dependencies = builder()

        dependencies.forEach {
            $0.register(self)
        }
    }

    // Workaround for https://bugs.swift.org/browse/SR-11628
    // Function builders will fail with 0 or 1 arguments
    // It looks like there is a fix and it should be available in Swift 5.3
    public convenience init(_ dependency: Dependency) {
        self.init()
        dependency.register(self)
    }

    public func register(swoin: Swoin) {
        swoin.load(self)
    }

    func register<T>(_ type: T.Type = T.self,
                     named name: String? = nil,
                     cacheType: CacheType,
                     factory: @escaping () -> T) {
        let typeKey = ObjectIdentifier(T.self).hashValue

        let entry = DependencyEntry(key: typeKey, named: name, cacheType: cacheType, factory: factory)

        if dependencies[typeKey] != nil {
            dependencies[typeKey]?[name] = entry
        } else {
            dependencies[typeKey] = [name: entry]
        }
    }

    func bind<ExistingType, AdditionalType>(
        additionalType: AdditionalType.Type,
        to existingType: ExistingType.Type,
        named name: String?,
        converter: @escaping (ExistingType) -> AdditionalType = { existing in existing as! AdditionalType }
    ) {
        let typeKey = ObjectIdentifier(AdditionalType.self).hashValue

        guard let entry = find(existingType, named: name) else {
            fatalError("Cannot bind a secondary type to a type that is not already registered")
        }

        let boundEntry = DependencyEntry<AdditionalType>(key: typeKey, named: name, cacheType: entry.cacheType) {
            let value = self.resolve(existingType, named: name)
            return converter(value)
        }

        if dependencies[typeKey] != nil {
            dependencies[typeKey]?[name] = boundEntry
        } else {
            dependencies[typeKey] = [name: boundEntry]
        }
    }

    func resolve<T>(_ type: T.Type = T.self, named name: String? = nil) -> T {
        if let entry = find(type, named: name) {
            let cache = self.cacheHolder.getCache(type: entry.cacheType)

            if let result = cache.resolve(entry: entry) {
                return result
            }
        }

        fatalError("Dependency not registered for type \(T.self) named: \(name ?? "NO NAME")")
    }

    func find<T>(_ type: T.Type = T.self, named name: String? = nil) -> DependencyEntry<T>? {
        let typeKey = ObjectIdentifier(T.self).hashValue

        if let dependenciesOfType = dependencies[typeKey] {
            return dependenciesOfType[name] as? DependencyEntry<T>
        }

        return nil
    }
}

@_functionBuilder
public struct ModuleBuilder {
    public static func buildBlock(_ dependencies: Dependency...) -> [Dependency] {
        return dependencies
    }
}
