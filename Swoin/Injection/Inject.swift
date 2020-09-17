//
//  Inject.swift
//  Swoin
//
//  Created by Adam Polt on 9/11/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

@propertyWrapper
public struct Inject<T> {
    private var dependency: T!

    private let name: String?

    private let swoin: Swoin?

    public var wrappedValue: T {
        mutating get {
            if dependency == nil {
                self.dependency = swoin?.get(T.self, named: name) ?? Swoin.global.get(T.self, named: name)
            }

            return dependency
        }
    }

    public init(named name: String? = nil, swoin: Swoin? = nil) {
        self.name = name
        self.swoin = swoin
    }
}
