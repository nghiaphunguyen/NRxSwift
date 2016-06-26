# NRxSwift 0.1.1
**NRxSwift** provides NKObservable - un-interrupted observable. It is extended from [RxSwift](https://github.com/ReactiveX/RxSwift)

**This library will bring the [Bolts](https://github.com/BoltsFramework/Bolts-ObjC) concept to Rx**

# CHANGE LOG

**v0.1**

# INSTALLATION

### Pod
```bash
use_frameworks!

pod 'NRxSwift'
```

### Carthage
```bash
github 'nghiaphunguyen/NRxSwift'
```

# USAGE

```swift
import NRxSwift
import RxSwift
```

##### Create observable
```swift
NKObservable.nk_just(1)

NKObservable.nk_error(Error.SomeErrorType)

NKObservable.nk_create { (observer) in
            observer.nk_setValue("Success")
        }
```

##### Stream
```swift
validateObservable.nk_continueWithSuccessCloure { (element) -> Observable<NKResult> in
            return postMessageObservable
        }.nk_continueWithCloure { (element) -> Observable<NKResult> in
            return resetSomeStuffsObservable
        }.subscribeNext { (result) in 
        	// the error will be handled in this closure, not subscribeError anymore
            // do something
        }.addDisposableTo(self.disposeBag)
```