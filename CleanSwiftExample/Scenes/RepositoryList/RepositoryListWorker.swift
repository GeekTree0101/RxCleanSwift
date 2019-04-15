import Foundation
import RxSwift

class RepositoryListWorker {
    
    static func load(since: Int?) -> Single<[Repository]> {
        return RepoAPI.loadRepository(since: since).map({ repositries -> [Repository] in
            for repo in repositries {
                DataProvider.shared.save(.repository(repo.id), model: repo)
            }
            return repositries
        })
    }
}
