import RxSwift
import RxCocoa

struct RepositoryShowModels {
    
    struct RepositoryShowComponent {
        
        struct Request {
            var id: Int
        }
        
        struct Response {
            var repo: Repository
        }
        
        struct ViewModel {
            var repoReactor: RepoReactor
        }
    }
    
    struct RepositoryShowDismiss {
        
        struct Request {
            
        }
        
        struct Response {
            
        }
        
        struct ViewModel {
            
        }
    }
}
