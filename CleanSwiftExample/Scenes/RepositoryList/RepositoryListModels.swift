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
            
            struct CellViewModel {
                
                struct State {
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
                
                let state = BehaviorRelay<State?>(value: nil)
                let identifier: Int
                
                private let disposeBag = DisposeBag()
                
                init(_ repo: Repository) {
                    self.identifier = repo.id
                    self.state.accept(State(repo))
                }
            }
            
            var repoCellViewModels: [CellViewModel]
            
            init(_ repositries: [Repository]) {
                self.repoCellViewModels = repositries.map({ CellViewModel($0) })
            }
        }
    }
    
    struct RepositoryCell {
        
        struct Request {
            var repository: Repository
        }
        
        struct Response {
            var repository: Repository
        }
        
        struct ViewModel {
            
            var id: Int
            var state: RepositorySequence.ViewModel.CellViewModel.State
            
            init(_ repo: Repository) {
                self.id = repo.id
                self.state = .init(repo)
            }
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
