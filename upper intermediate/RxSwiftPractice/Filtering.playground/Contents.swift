import RxSwift

let disposeBag = DisposeBag()

print("=== ignoreElements ===")
let 취침모드 = PublishSubject<String>()
취침모드
    .ignoreElements()
    .subscribe{ _ in
        print("낮")
    }
    .disposed(by: disposeBag)

취침모드.onNext("스피커")
취침모드.onNext("스피커")
취침모드.onNext("스피커")
취침모드.onCompleted()
취침모드.onNext("새로운스피커")

print("=== elementAt ===")
let WakeupInTwice = PublishSubject<String>()
WakeupInTwice
    .element(at: 2)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
WakeupInTwice.onNext("index0")
WakeupInTwice.onNext("index1")
WakeupInTwice.onNext("index2")
WakeupInTwice.onNext("index3")

print("=== filter ===")
Observable.of(1,2,3,4,5,6,7,8)
    .filter{$0%2 == 0}
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("=== skip ===")
Observable.of("1","2","3","4","5","6","7","8")
    .skip(5)
    .subscribe(onNext: {
        print($0)
    })

print("=== skipWhile ===")
Observable.of("1","2","3","4","5","6", "7","8")
    .skip(while: {
        $0 != "6"
    })
    .subscribe(onNext: {
        print($0)
    })

print("=== skipUntil ===")
let client = PublishSubject<String>()
let openHour = PublishSubject<String>()
client
    .skip(until: openHour)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
client.onNext("1")
client.onNext("2")
openHour.onNext("Ring Ring")
client.onNext("3")

print("=== take ===")
Observable.of("1", "2", "3", "4", "5")
    .take(3)
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

print("=== takeWhile ===")
Observable.of("1", "2", "3", "4", "5")
    .take(while: {
        $0 != "3"
    })
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

print("=== enumerated ===")
Observable.of("1", "2", "3", "4", "5")
    .enumerated()
    .take(while: {
        $0.index < 3
    })
    .subscribe(onNext : {
        print($0)
    })
    .disposed(by: disposeBag)

print("=== takeUntil ===")
let 수강신청 = PublishSubject<String>()
let 신청마감 = PublishSubject<String>()
수강신청
    .take(until: 신청마감)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
수강신청.onNext("1")
수강신청.onNext("2")
신청마감.onNext("땡")
수강신청.onNext("3")

print("=== distinctUntilChanged ===")
Observable.of("1", "1", "2", "2", "3", "1", "1")
    .distinctUntilChanged()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
