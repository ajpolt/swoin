# Swoin

Swoin is a dependency injection framework for Swift, inspired by [Koin](https://github.com/InsertKoinIO/koin)

## Getting Started

Add the framework to your project, e.g., with Cocoapods:

`pod 'Swoin', :git => 'https://github.com/ajpolt/swoin.git'`

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
