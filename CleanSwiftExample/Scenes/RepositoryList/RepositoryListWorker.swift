import Foundation
import RxSwift

class RepositoryListWorker {
    
    static func load(since: Int?) -> Single<[Repository]> {
        return RepoAPI.loadRepository(since: since)
    }
}
