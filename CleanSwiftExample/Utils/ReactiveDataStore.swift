import Foundation
import RxSwift
import RxCocoa

public class ReactiveDataStore<T> {
    
    public let store: BehaviorRelay<T>
    
    public var value: T {
        return store.value
    }
    
    init(_ data: T) {
        store = .init(value: data)
    }
    
    public func update(_ data: T) {
        store.accept(data)
    }
    
    public func asObservable() -> Observable<T> {
        return store.asObservable()
    }
}
