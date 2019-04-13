import RxSwift
import RxCocoa

struct RepositoryListModel {
    
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
        var repos: [Repository]
    }
}
