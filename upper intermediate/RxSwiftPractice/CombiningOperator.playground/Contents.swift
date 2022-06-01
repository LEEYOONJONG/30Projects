import UIKit
import RxSwift

let disposeBag = DisposeBag()

print("=== startWith ===")
let 노랑반 = Observable.of("Yellow", "White", "Black")
노랑반
    .enumerated()
    .map{ index, element in
        return element + "어린이" + "\(index)"
    }
    .startWith("선생님")
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("=== concat1 ===")
let 노랑반어린이들 = Observable<String>.of("황인", "백인", "흑인")
let 선생님 = Observable<String>.of("선생님")

let 줄서서걷기 = Observable
    .concat([선생님, 노랑반어린이들])

줄서서걷기
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("=== concat2 ===")
선생님
    .concat(노랑반어린이들)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("=== concatMap ===")
let 어린이집:[String: Observable<String>] = [
    "노랑반" : Observable.of("황인", "백인", "흑인"),
    "파랑반" : Observable.of("1살", "2살")
]
Observable.of("노랑반", "파랑반")
    .concatMap { 반 in
        어린이집[반] ?? .empty()
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("=== merge1 ===")
let 강북 = Observable.from(["강북구", "성북구", "중랑구"])
let 강남 = Observable.from(["동작구", "서초구", "강남구"])
Observable.of(강북, 강남)
    .merge()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("=== merge2 ===")
Observable.of(강북, 강남)
    .merge(maxConcurrent: 1)
    .subscribe(onNext : {
        print($0)
    })
    .disposed(by: disposeBag)

print("=== combineLatest ===")
let 성 = PublishSubject<String>()
let 이름 = PublishSubject<String>()

let 성명 = Observable
    .combineLatest(성, 이름) { 성, 이름 in
        성 + 이름
    }
성명
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

성.onNext("이")
이름.onNext("윤종")
이름.onNext("지은")
이름.onNext("환")
성.onNext("김")
성.onNext("박")
성.onNext("최")

print("=== combineLatest2 ===")
let 날짜표시형식 = Observable<DateFormatter.Style>.of(.short, .long)
let 현재날짜 = Observable<Date>.of(Date())

let 현재날짜표시 = Observable
    .combineLatest(
        날짜표시형식,
        현재날짜,
        resultSelector: { 형식, 날짜 -> String in
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = 형식
            return dateFormatter.string(from: 날짜)
        }
    )

현재날짜표시
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("=== combineLatest3 ===")
let lastName = PublishSubject<String>() // 성
let firstName = PublishSubject<String>() // 이름

let fullName = Observable
    .combineLatest([firstName, lastName]){ name in
        name.joined(separator: " ")
    }
fullName
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

lastName.onNext("Kim")
firstName.onNext("Paul")
firstName.onNext("Shawn")

print("=== zip ===")
enum 승패 {
    case 승
    case 패
}

let 승부 = Observable<승패>.of(.승, .승, .패, .승, .패)
let 선수 = Observable<String>.of("한국", "스위스", "미국", "브라질", "일본", "중국")

let 시합결과 = Observable
    .zip(승부, 선수) { 결과, 대표선수 in
        return 대표선수 + "선수" + "\(결과)"
    }
시합결과
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("=== withLatestFrom1 ===")
let bang = PublishSubject<Void>()
let 달리기선수 = PublishSubject<String>()

bang
    .withLatestFrom(달리기선수)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
달리기선수.onNext("1")
달리기선수.onNext("2")
달리기선수.onNext("3")
bang.onNext(Void())
bang.onNext(Void())


print("=== sample ===")
let 출발 = PublishSubject<Void>()
let F1선수 = PublishSubject<String>()
F1선수
    .sample(출발)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

F1선수.onNext("1")
F1선수.onNext("2")
F1선수.onNext("3")
출발.onNext(Void())
출발.onNext(Void())
출발.onNext(Void())

print("=== amb ===")
let 버스1 = PublishSubject<String>()
let 버스2 = PublishSubject<String>()

let 버스정류장 = 버스1.amb(버스2)
버스정류장
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
버스2.onNext("버스2-승객0")
버스1.onNext("버스1-승객0")
버스1.onNext("버스1-승객1")
버스2.onNext("버스2-승객1")
버스1.onNext("버스1-승객1")
버스2.onNext("버스2-승객2")

print("=== switchLatest ===")
let 학생1 = PublishSubject<String>()
let 학생2 = PublishSubject<String>()
let 학생3 = PublishSubject<String>()

let 손들기 = PublishSubject<Observable<String>>() // 옵저버블스트링을 뿜는 퍼블리시서브젝트
let 손든사람만말할수있는교실 = 손들기.switchLatest()
손든사람만말할수있는교실
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

손들기.onNext(학생1) // 학생1이라는 옵저버블 스트링타입을 내뱉는다 // 들어온 처음이자 마지막 시퀀스
학생1.onNext("학생1 : 안녕") // 들어온 학생1에 대한 이벤트만 구독 -> 출력
학생2.onNext("학생2 : 헬로") // 들어오지 않은 학생2에 대해선 무시

손들기.onNext(학생2) // 최신의 값이 학생2
학생2.onNext("학생2 : 2번")
학생1.onNext("학생1 : 1번") // 이는 무시

손들기.onNext(학생3) // 가장 최신의 값은 학생3
학생2.onNext("학생2 : 2nd")
학생1.onNext("학생1 : 1st")
학생3.onNext("학생3 : 3rd") // 최신의 값이 학생3이기에 이것만 출력.

손들기.onNext(학생1)
학생1.onNext("학생1 : ") // 학생1만 내뱉음.
학생2.onNext("학생2 : ")
학생3.onNext("학생3 : ")
학생2.onNext("학생2 : ")



print("=== reduce ===")
Observable.from((1...10))
    .reduce(0, accumulator: { summary, newValue in
        return summary + newValue
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("=== scan ===")
Observable.from((1...10))
    .scan(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
