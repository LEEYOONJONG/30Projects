import Foundation
import RxSwift

print("===just===")
Observable<Int>.just(1)
    .subscribe(onNext: { print($0) })

print("===of1===")
Observable<Int>.of(1,2,3,4,5)
    .subscribe(onNext: { print($0) })

print("===of2===")
Observable.of([1,2,3,4,5])
    .subscribe(onNext: { print($0) })

print("===from===")
Observable.from([1,2,3,4,5])
    .subscribe(onNext: { print($0) })

print("===subscribe1===")
Observable<Int>.of(1,2,3,4,5)
    .subscribe { print($0)  }

print("===subscribe2===")
Observable<Int>.of(1,2,3,4,5)
    .subscribe {
        if let element = $0.element {
            print(element)
        }
    }

print("===empty===")
Observable.empty()
    .subscribe{ print($0) }

print("===empty2===")
Observable<Void>.empty()
    .subscribe{ print($0) }

print("===empty3===")
Observable<Void>.empty()
    .subscribe(onNext: {
        
    },
               onCompleted: {
        print("Completed")
    }
    )

print("=== never ===")
Observable.never()
    .debug("Naver")
    .subscribe(
        onNext: { print($0) },
        onCompleted: { print("Completed") }
    )
        
print("=== range ===")
Observable.range(start: 2, count: 9)
    .subscribe(
        onNext: {
            print("2 * \($0) = \(2*$0)")
        }
    )

print("=== dispose ===")
Observable.of(1, 2, 3)
    .subscribe(
        onNext: { print($0) }
    )
    .dispose()

print("=== disposeBag ===")
let disposeBag = DisposeBag()
Observable<Int>.of(1, 2, 3)
    .subscribe{
        print($0)
    }
    .disposed(by: disposeBag)

print("=== create1 ===")
Observable.create{ observer -> Disposable in
    observer.onNext(1)
    observer.onCompleted()
    observer.onNext(2)
    return Disposables.create()
}
.subscribe{ print($0) }
.disposed(by: disposeBag)

print("=== create2 ===")
enum MyError:Error{
    case anError
}
Observable<Int>.create { observer -> Disposable in
    observer.onNext(1)
    observer.onError(MyError.anError)
    observer.onCompleted()
    observer.onNext(2)
    return Disposables.create()
}
.subscribe (
    onNext: { print($0) },
    onError: { print($0) },
    onCompleted: { print("completed") },
    onDisposed: { print("disposed") }
)
.disposed(by: disposeBag)

print("--- create3 ---")
Observable<Int>.create { observer -> Disposable in
    observer.onNext(1)
//    observer.onError(MyError.anError)
//    observer.onCompleted()
    observer.onNext(2)
    return Disposables.create()
}
// 위는 정의에 불과하다. 구독을 해줘야
    .subscribe(
    onNext: { print($0) },
    onError: { print($0) },
    onCompleted: { print("completed") },
    onDisposed: { print("disposed") }
)
//    .disposed(by: disposeBag)

print("=== deferred1 ===")
Observable.deferred {
    Observable.of(1,2,3)
}
.subscribe{ print($0) }
.disposed(by: disposeBag)

print("=== deferred2 ===")
var flipped:Bool = false
let factory:Observable<String> = Observable.deferred {
    flipped = !flipped
    if flipped {
        return Observable.of("🫴🏻")
    } else {
        return Observable.of("🫳🏻")
    }
}
for _ in 0...3 {
    factory.subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
}
