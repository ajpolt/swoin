//
//  ResolvableDependency.swift
//  Swoin
//
//  Created by Adam Polt on 9/11/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

public class ResolvableDependency<T>: Dependency {
    public let factory: () -> T
    public let name: String?
    public let cacheType: CacheType

    init(_ type: T.Type = T.self, named name: String? = nil, cacheType: CacheType, factory: @escaping () -> T) {
        self.factory = factory
        self.name = name
        self.cacheType = cacheType
    }

    public func register(_ module: Module) {
        module.register(T.self, named: name, cacheType: self.cacheType, factory: factory)
    }

    public func bind<NewType>(_ type: NewType.Type) -> BoundDependency<T, NewType> {
        let defaultConverter: (T) -> NewType = { dependency in
            dependency as! NewType
        }

        return bind(type, defaultConverter)
    }

    public func bind<NewType>(_ newType: NewType.Type,
                              _ converter: @escaping (T) -> NewType) -> BoundDependency<T, NewType> {
        if T.self == NewType.self {
            fatalError("Attempt to bind \(NewType.self) to \(T.self) to . Binding twice to the same type is not allowed.")
        }

        return BoundDependency<T, NewType>(wrappedDependency: self, wrappedFactory: self.factory, converter: converter)
    }

    public func then(_ closure: @escaping (T) -> Void) -> ResolvableDependency<T> {
        return ResolvableDependency<T>(T.self, named: name, cacheType: self.cacheType) {
            let dependency = self.factory()
            closure(dependency)
            return dependency
        }
    }
}
