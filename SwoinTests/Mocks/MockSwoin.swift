//
//  MockSwoin.swift
//  SwoinTests
//
//  Created by Adam Polt on 9/15/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

@testable import Swoin

class MockSwoin: Swoin {
    public var values: [Int: Any] = [:]
    
    private var getCounts: [Int: [String?: Int]] = [:]
    
    var loadCount = 0
    
    init() {}
    
    init<T>(_ type: T.Type = T.self, value: T) {
        let id = ObjectIdentifier(type).hashValue
        values[id] = value
    }
    
    func set<T>(_ type: T.Type = T.self, value: T) {
        let id = ObjectIdentifier(type).hashValue
        values[id] = value
    }
    
    public func getCount<T>(type: T.Type, named: String? = nil) -> Int {
        let id = ObjectIdentifier(type).hashValue
        
        return getCounts[id]?[named] ?? 0
    }
    
    override public func get<T>(_ type: T.Type = T.self, named name: String? = nil) -> T {
        let id = ObjectIdentifier(type).hashValue
        
        if getCounts[id] != nil {
            getCounts[id]![name] = (getCounts[id]![name] ?? 0) + 1
        } else {
            getCounts[id] = [name: 1]
        }
        
        return values[id] as! T
    }
    
    override func load(_ module: Module) {
        loadCount += 1
    }
}
