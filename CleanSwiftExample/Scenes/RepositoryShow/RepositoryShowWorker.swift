import Foundation
import RxSwift

class RepositoryShowWorker {
    
    func loadCachedRepository(_ id: Int) -> Single<Repository> {
        return DataProvider.shared.loadObservable(.repository(id), type: Repository.self)
    }
}
