import Foundation
import RxSwift

class RepositoryShowWorker {
    
    func loadCachedRepository(_ id: Int) -> Single<Repository> {
        return DataProvider.shared.loadObservable(.repository(id), type: Repository.self)
    }
    
    func togglePin(_ id: Int) -> Single<Repository> {
        return DataProvider.shared
            .loadObservable(.repository(id), type: Repository.self)
            .map({ repo -> Repository in
                var newRepo = repo
                newRepo.isPinned = !newRepo.isPinned
                DataProvider.shared.save(.repository(repo.id), model: newRepo)
                return newRepo
            })
    }
}
