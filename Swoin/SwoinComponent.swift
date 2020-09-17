//
//  SwoinComponent.swift
//  Swoin
//
//  Created by Adam Polt on 9/17/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

public protocol SwoinComponent {
    static var swoin: Swoin? { get }
    func get<T>(_ type: T.Type, named name: String?, swoin: Swoin?) -> T
}

public extension SwoinComponent {
    static var swoin: Swoin? {
        return Swoin.global
    }

    func get<T>(_ type: T.Type = T.self, named name: String? = nil, swoin: Swoin? = Self.swoin) -> T {
        return swoin?.get(type, named: name) ?? Swoin.global.get(type, named: name)
    }
}
