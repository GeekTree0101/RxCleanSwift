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
            
            var profileURL: URL?
            var title: String?
            var desc: String?
            var isPinned: Bool
            
            init(_ repo: Repository) {
                self.profileURL =  repo.user?.profileURL
                self.title = repo.user?.username
                self.desc = repo.desc
                self.isPinned = repo.isPinned
            }
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
