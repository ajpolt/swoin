//
//  Factory.swift
//  Swoin
//
//  Created by Adam Polt on 9/11/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

final class Factory<T>: ResolvableDependency<T> {
    public init(_ type: T.Type = T.self, named name: String? = nil, factory: @escaping () -> T) {
        super.init(type, named: name, cacheType: .factory, factory: factory)
    }
}

public func factory<T>(_ type: T.Type = T.self, named name: String? = nil, factory: @escaping () -> T) -> ResolvableDependency<T> {
        return Factory(type, named: name, factory: factory)
}
