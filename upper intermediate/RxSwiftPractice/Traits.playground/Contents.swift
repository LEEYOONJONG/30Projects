import RxSwift
import Foundation

let disposeBag = DisposeBag()
enum TraitsError:Error{
    case single
    case maybe
    case completable
}

print("=== Single ===")
Single<String>.just("yoonjong")
    .subscribe(
    onSuccess: { print($0) },
    onFailure: { print("error: \($0)") },
    onDisposed: { print("disposed") }
    )
    .disposed(by: disposeBag)

print("=== Single2 ===")
Observable<String>.just("yoonjong")
    .asSingle()
    .subscribe(
    onSuccess: { print($0) },
    onFailure: { print("error: \($0)") },
    onDisposed: { print("disposed") }
    )
    .disposed(by: disposeBag)

print("=== Single2-1 ===")
Observable<String>.create { observer -> Disposable in
    observer.onError(TraitsError.single)
    return Disposables.create()
}
.asSingle()
.subscribe(
    onSuccess: { print($0) },
    onFailure: { print("error :\($0)") },
    onDisposed: { print("disposed") }
)
.disposed(by: disposeBag)

print("=== Single3 ===")
struct SomeJSON: Decodable{
    let name:String
}
enum JSONError: Error{
    case decodingError
}
let json1 = """
    {"name" : "park"}
"""
let json2 = """
    {"my_name" : "yoon"}
"""
// decoding 함수 만들기
func decode(json:String) -> Single<SomeJSON> {
    Single<SomeJSON>.create{ observer -> Disposable in
        guard let data = json.data(using: .utf8),
              let json = try? JSONDecoder().decode(SomeJSON.self, from: data) else {
            observer(.failure(JSONError.decodingError))
            return Disposables.create()
        }
        observer(.success(json))
        return Disposables.create()
    }
}
decode(json: json1) // 아무일도 일어나지 않음. 왜냐. 싱글이라는 옵저버블 시퀀스를 만들었을 뿐. 구독하지 않았기때문에
    .subscribe { // 이렇게 구독해줘야!
        switch $0{
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)
decode(json: json2) // 아무일도 일어나지 않음. 왜냐. 싱글이라는 옵저버블 시퀀스를 만들었을 뿐. 구독하지 않았기때문에
    .subscribe { // 이렇게 구독해줘야!
        switch $0{
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)

print("=== Maybe1 ===")
Maybe<String>.just("yoonjong")
    .subscribe(
        onSuccess: { print($0) }, // observable과 비교하면 onNext 대신 onSuccess로 표현하는 것만 다르다.
        onError: { print($0) },
        onCompleted: { print("completed") },
        onDisposed: { print("disposed") }
    )
    .disposed(by:disposeBag)

print("=== Maybe2 ===")
Observable<String>.create { observer -> Disposable in
    observer.onError(TraitsError.maybe)
    return Disposables.create()
}
.asMaybe()
.subscribe(
    onSuccess: { print("성공 : \($0)") },
    onError: { print("에러 : \($0)") },
    onCompleted: { print("completed") },
    onDisposed: { print("disposed") }
)
.disposed(by: disposeBag)
    
