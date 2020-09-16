//
//  BoundDependency.swift
//  Swoin
//
//  Created by Adam Polt on 9/11/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

public class BoundDependency<ExistingType, AdditionalType>: Dependency {
    let wrappedDependency: Dependency
    let wrappedFactory: () -> ExistingType

    public let name: String?
    public let cacheType: CacheType

    let converter: (ExistingType) -> AdditionalType

    init(wrappedDependency: Dependency,
         wrappedFactory: @escaping () -> ExistingType,
         converter: @escaping (ExistingType) -> AdditionalType) {
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

    public func bind<NewType>(_ type: NewType.Type) -> BoundDependency<ExistingType, NewType> {
        return self.bind(type) {
            $0 as! NewType
        }
    }

    public func bind<NewType>(_ type: NewType.Type,
                              _ converter: @escaping (ExistingType) -> NewType)
                                -> BoundDependency<ExistingType, NewType> {
        guard NewType.self != ExistingType.self else {
            fatalError("Attempt to bind \(NewType.self) to \(ExistingType.self) which is already bound")
        }

        guard NewType.self != AdditionalType.self else {
            fatalError("Attempt to bind \(NewType.self) to \(AdditionalType.self) which is already bound.")
        }

        return BoundDependency<ExistingType, NewType>(wrappedDependency: self,
                                                      wrappedFactory: self.wrappedFactory,
                                                      converter: converter)
    }

    public func then(_ closure: @escaping (ExistingType) -> Void) -> ResolvableDependency<ExistingType> {
        return ResolvableDependency<ExistingType>(ExistingType.self, named: name, cacheType: self.cacheType) {
            let value = self.wrappedFactory()
            closure(value)
            return value
        }
    }
}
