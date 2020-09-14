//
//  Get.swift
//  Swoin
//
//  Created by Adam Polt on 9/11/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

public func get<T>(_ type: T.Type = T.self, named name: String? = nil, swoin: Swoin = Swoin.global) -> T {
    return swoin.get(type, named: name)
}
