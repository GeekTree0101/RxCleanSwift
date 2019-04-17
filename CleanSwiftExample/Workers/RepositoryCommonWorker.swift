import Foundation
import RxSwift
import RxCocoa

class RepositoryCommonWorker {
    
    func loadCachedRepository(_ id: Int) -> Single<Repository> {
        return DataProvider.shared.loadObservable(.repository(id), type: Repository.self)
    }
    
    func convertToRepositoryToDataStore(_ repository: Repository) -> ReactiveDataStore<Repository> {
        return .init(repository)
    }
    
    func convertToRepositoriesToDataStore(_ repositories: [Repository]) -> [ReactiveDataStore<Repository>] {
        return repositories.map({ .init($0) })
    }
}
