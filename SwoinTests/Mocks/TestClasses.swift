//
//  TestClasses.swift
//  SwoinTests
//
//  Created by Adam Polt on 9/16/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

class Thing {
    var value: String
    
    init(_ value: String) {
        self.value = value
    }
}

class DifferentThing: Thing {}

class OtherThing: DifferentThing {}

class ThingHolder {
    var thing: Thing
    
    init(_ thing: Thing) {
        self.thing = thing
    }
}
