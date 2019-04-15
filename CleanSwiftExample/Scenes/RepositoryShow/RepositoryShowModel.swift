import RxSwift
import RxCocoa

struct RepositoryShowModel {
    
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
