//
//  Dependency.swift
//  Swoin
//
//  Created by Adam Polt on 9/11/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

public protocol Dependency {
    var name: String? { get }
    var cacheType: CacheType { get }

    func register(_ module: Module)
    func bind<NewType>(_ type: NewType.Type) -> Dependency
}
