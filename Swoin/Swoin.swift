//
//  Swoin.swift
//  Swoin
//
//  Created by Adam Polt on 9/11/20.
//  Copyright © 2020 Adam Polt. All rights reserved.
//

public class Swoin {
    public static let emptyLogger: (String) -> Void = { _ in }
    public static let printLogger: (String) -> Void = { print("Swoin: \($0)") }

    public static var global: Swoin!

    public var logger: ((String) -> Void) = emptyLogger

    var modules: [Module] = []

    public static func start(@DIBuilder builder: () -> Swoin) -> Swoin {
        return builder()
    }

    public init(_ modules: [Module] = [], logger: @escaping ((String) -> Void) = Swoin.emptyLogger) {
        self.logger = logger
        self.modules = modules
    }

    public func load(_ modulesToLoad: [Module]) {
        logger("Loading \(modules.count) modules")

        modulesToLoad.forEach {
            load($0)
        }
    }

    public func load(_ module: Module) {
        logger("Loading \(module)")

        self.modules.append(module)
    }

    public func unload(_ modulesToUnload: [Module]) {
        logger("unloading \(modules.count) modules")

        modulesToUnload.forEach {
            unload($0)
        }
    }

    public func unload(_ module: Module) {
        logger("Unloading \(module)")

        modules.removeAll { $0 === module }
    }

    public func get<T>(_ type: T.Type = T.self, named name: String? = nil) -> T {
        logger("Resolving dependency for \(T.self) \(name != nil ? "named \(name!)" : "")")

        let module = modules.last {
             $0.find(type, named: name) != nil
        }

        if let module = module {
            logger("Found dependency in \(module)")
            return module.resolve(type, named: name)
        }

        fatalError("Dependency not registered for type \(T.self) named: \(name ?? "NO NAME")")
    }
}

@discardableResult
public func startSwoin(@DIBuilder builder: () -> Swoin) -> Swoin {
    if Swoin.global != nil {
        fatalError("Swoin is already started. stop() must be called before calling start again")
    }

    Swoin.global = Swoin.start(builder: builder)

    return Swoin.global
}

public func stopSwoin() {
    Swoin.global = nil
}

public protocol SwoinParameter {
    func register(swoin: Swoin)
}

public struct modules: SwoinParameter {
    let modules: [Module]

    public init(_ modules: [Module]) {
        self.modules = modules
    }

    public func register(swoin: Swoin) {
        swoin.load(self.modules)
    }
}

public struct logger: SwoinParameter {
    let logger: (String) -> Void

    public init(_ logger: @escaping (String) -> Void) {
        self.logger = logger
    }

    public func register(swoin: Swoin) {
        swoin.logger = self.logger
    }
}

@_functionBuilder
public struct DIBuilder {
    public static func buildBlock(_ parameters: SwoinParameter...) -> Swoin {
        let swoin = Swoin()

        parameters.forEach {
            $0.register(swoin: swoin)
        }

        return swoin
    }
}
