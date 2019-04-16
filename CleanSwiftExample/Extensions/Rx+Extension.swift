import RxSwift
import RxCocoa
import RxOptional

extension Observable {
    
    func onSuccess() -> Observable<E> {
        return self.materialize()
            .map { event -> Element? in
                switch event {
                case .next(let element):
                    return element
                default:
                    return nil
                }
            }
            .filterNil()
    }
    
    func onError() -> Observable<Error> {
        return self.materialize()
            .map { event -> Error? in
                switch event {
                case .error(let error):
                    return error
                default:
                    return nil
                }
            }
            .filterNil()
    }
}

extension ObservableType {
    
    func withValue<T>(type: T.Type, value: T) -> Observable<T> {
        return self.map { _ -> T? in return nil }
            .replaceNilWith(value)
    }
}
