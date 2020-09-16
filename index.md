# Swoin

Swoin is a dependency injection framework for Swift, inspired by [Koin](https://github.com/InsertKoinIO/koin)

## Getting Started

Add the framework to your project, e.g., with Cocoapods:

`pod 'Swoin'`

Add your dependencies to some modules:

        let appModule = Module {
            single { CustomNavigationController() }
                .bind(UINavigationController.self)
                
            weak(named: "TestSubject") { PublishSubject<Void>() }
                .bind(Observable<Void>.self) { $0.asObservable() }
                .bind(AnyObserver<Void>.self) { $0.asObserver() }
                
            weak { HomeViewModel(input: get(), output: get()) }
            weak { HomeViewController(viewModel: get(), view: get()) }
            weak { HomeView() }
        }
        
        let thingModule = Module {
            factory { Thing() }
            
            single { ThingFetcher(thing: get()) }
                .bind(IntFetcher.self)
                .bind(StringFetcher.self)
        }
        
Start the global Swoin instance:

        startSwoin {
            appModule
            thingModule
            logger(Swoin.printLogger)
        }
        
Inject fields lazily, using @Inject:

        @Inject private var navigationController: CustomNavigationController
        
Or eagerly, using `get()`:

        let controller: TipsViewController = get()
        
        rootViewController.pushViewController(controller, animated: true)
        
Named dependencies are supported:

        @Inject(named: "TestSubject") private var testObservable: Observable<Void>
        
        let observer: PublishSubject = get(named: "TestSubject")

## Cache types

Three types of caching strategies are supported:

- A `single` dependency is created once as long as the module remains loaded, i.e., a singleton
- A `factory` dependency is re-created any time it is resolved
- A `weak` dependency is re-created if there are no other strong references to any previously created instance of that type

## Binding additional types

You may bind multiple types to a dependency registration using `.bind`, passing an optional closure to convert to that type:

        weak(named: "TestSubject") { PublishSubject<Void>() }
                .bind(Observable<Void>.self) { $0.asObservable() }
                .bind(AnyObserver<Void>.self) { $0.asObserver() }
                
Bound types share the same name and cache strategy as the dependency they are bound to.

The closure is optional if the original type implements a protocol, since the default is `{ $0 as! NewType }`, but obviously this will result in a runtime crash if the forced cast is not possible.

## Running code after initialization:

You may perform an action after a dependency is initialized using `.then`:

        private class CircularDependencyOne {
            let dependencyTwo: CircularDependencyTwo

            init(_ dependencyTwo: CircularDependencyTwo) {
                self.dependencyTwo = dependencyTwo
            }
        }

        private class CircularDependencyTwo {
            var dependencyOne: CircularDependencyOne?
        }
        
        let testModule = Module {
                single { CircularDependencyOne(get()) }
                    .then {
                        $0.dependencyTwo.dependencyOne = $0
                    }

                single { CircularDependencyTwo() }
        }
