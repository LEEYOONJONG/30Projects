import RxSwift
let disposeBag = DisposeBag()

print("=== PublishSubject ===")
let publishSubject = PublishSubject<String>()
publishSubject.onNext("1번")

let 구독자1 = publishSubject
    .subscribe(onNext: { print("첫번째구독자", $0) })


publishSubject.onNext("2번")
publishSubject.on(.next("3번"))
구독자1.dispose() // 수동으로 dispose

let 구독자2 = publishSubject
    .subscribe(onNext: { print("두번째구독자", $0) })
publishSubject.onNext("4번")
publishSubject.onCompleted()
publishSubject.onNext("5번")
구독자2.dispose()

publishSubject
    .subscribe{
        print("세번째 구독: ", $0.element ?? $0)
    }
    .disposed(by: disposeBag)
publishSubject.onNext("6번")


print("=== behaviorSubject ===")
enum SubjectError:Error {
    case error1
}

let behaviorSubject = BehaviorSubject<String>(value: "0. 초기값") // 반드시 초기값 있어야
behaviorSubject.onNext("1. 첫번째")
behaviorSubject.subscribe {
    print("첫번째구독: ", $0.element ?? $0)
}
.disposed(by: disposeBag)
behaviorSubject.onError(SubjectError.error1) // 임의의 에러 발생시킴

behaviorSubject.subscribe {
    print("두번째구독: ", $0.element ?? $0)
}
.disposed(by: disposeBag)

let value = try? behaviorSubject.value()
print(value)



print("=== replaySubject ===")
let replaySubject = ReplaySubject<String>.create(bufferSize: 2) // initialize, value값 넣는 게 아니라 create로 만들어야
replaySubject.onNext("1번")
replaySubject.onNext("2번")
replaySubject.onNext("3번")
replaySubject.subscribe{
    print("첫번째 구독 : ", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.subscribe {
    print("두번째 구독 : ", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.onNext("4번")
replaySubject.onError(SubjectError.error1)
replaySubject.dispose()

replaySubject.subscribe{
    print("세번째 구독 : ", $0.element ?? $0)
}
.disposed(by: disposeBag)
