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
                
                enum Action {
                    case didTapProfile
                }
                
                let state = BehaviorRelay<State?>(value: nil)
                let action = PublishRelay<Action>()
                let identifier: Int
                
                private let disposeBag = DisposeBag()
                
                init(_ repo: Repository) {
                    self.identifier = repo.id
                    self.state.accept(State(repo))
                    
                    let observe = DataProvider.shared
                        .observe(.repository(repo.id),
                                 type: Repository.self)
                    
                    observe.map({ State($0) })
                        .bind(to: state)
                        .disposed(by: disposeBag)
                }
            }
            
            var repoCellViewModels: [CellViewModel]
            
            init(_ repositries: [Repository]) {
                self.repoCellViewModels = repositries.map({ CellViewModel($0) })
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
