import Foundation
import RxSwift

class RepositoryListWorker {
    
    func load(since: Int?) -> Single<[Repository]> {
        return RepoAPI.loadRepository(since: since)
    }
}
