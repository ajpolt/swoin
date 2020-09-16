//
//  MockFactoryCreator.swift
//  SwoinTests
//
//  Created by Adam Polt on 9/15/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

class MockFactoryCreator {
    var factoryRunCount = 0
    
    func getFactory<T>(for expectedValue: T) -> () -> T {
        return { [weak self] in
            self?.factoryRunCount += 1
            return expectedValue
        }
    }
    
    func doSomething() {
        print("whatever")
    }
}
