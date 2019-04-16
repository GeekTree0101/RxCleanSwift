import Foundation
import RxSwift

class RepositoryListWorker {
    
    let api: RepoAPI
    
    init(api: RepoAPI) {
        self.api = api
    }
    
    func loadRepositoryList(since: Int?) -> Single<[Repository]> {
        return self.api.loadRepository(since: since).map({ repositries -> [Repository] in
            for repo in repositries {
                DataProvider.shared.save(.repository(repo.id), model: repo)
            }
            return repositries
        })
    }
    
    func convertToRepositoryDataStore(_ repositories: [Repository]) -> [ReactiveDataStore<Repository>] {
        return repositories.map({ .init($0) })
    }
}
