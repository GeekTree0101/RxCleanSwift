import RxSwift
import RxCocoa

struct RepositoryListModels {
    
    struct RepositorySequence {
        struct Request {
            var since: Int?
            
            init(since: Int?) {
                self.since = since
            }
        }
        
        struct Response {
            var repos: [Repository]
        }
        
        struct ViewModel {
            var repoReactors: [RepoReactor]
        }
    }
    
    struct RepositoryShow {
        
        struct Request {
            var repoID: Int
        }
        
        struct Response {
            var repoID: Int
        }
        
        struct ViewModel {
            var repoID: Int
        }
    }
}
