//
//  Weak.swift
//  Swoin
//
//  Created by Adam Polt on 9/11/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

public final class weak<T>: ResolvableDependency<T> {
    public init(_ type: T.Type = T.self, named name: String? = nil, factory: @escaping () -> T) {
        super.init(type, named: name, cacheType: .weak, factory: factory)
    }
}
