//
//  BoundDependency.swift
//  Swoin
//
//  Created by Adam Polt on 9/11/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

public class BoundDependency<ExistingType, AdditionalType>: Dependency {
    private let wrappedDependency: Dependency
    private let wrappedFactory: () -> ExistingType

    public let name: String?
    public let cacheType: CacheType
    
    let converter: (ExistingType) -> AdditionalType
    
    init(wrappedDependency: Dependency, wrappedFactory: @escaping () -> ExistingType, converter: @escaping (ExistingType) -> AdditionalType) {
        self.wrappedDependency = wrappedDependency
        self.wrappedFactory = wrappedFactory
        self.name = wrappedDependency.name
        self.cacheType = wrappedDependency.cacheType
        self.converter = converter
    }
    
    public func register(_ module: Module) {
        wrappedDependency.register(module)
        
        module.bind(additionalType: AdditionalType.self, to: ExistingType.self, named: name, converter: self.converter)
    }
    
    public func bind<NewType>(_ type: NewType.Type) -> Dependency {
        return self.bind(type) {
            $0 as! NewType
        }
    }
    
    public func bind<NewType>(_ type: NewType.Type, _ converter: @escaping (ExistingType) -> NewType)  -> BoundDependency<ExistingType, NewType> {
        if NewType.self == ExistingType.self {
            fatalError("Attempt to bind \(ExistingType.self) to \(NewType.self). Binding twice to the same type is not allowed.")
        }
        if NewType.self == AdditionalType.self {
            fatalError("Attempt to bind \(AdditionalType.self) to \(NewType.self). Binding twice to the same type is not allowed.")
        }
        
        return BoundDependency<ExistingType, NewType>(wrappedDependency: self, wrappedFactory: self.wrappedFactory, converter: converter)
    }
    
    public func then(_ closure: @escaping (ExistingType) -> ()) -> Dependency {
        return ResolvableDependency<ExistingType>(ExistingType.self, named: name, cacheType: self.cacheType) {
            let value = self.wrappedFactory()
            closure(value)
            return value
        }
    }
}
