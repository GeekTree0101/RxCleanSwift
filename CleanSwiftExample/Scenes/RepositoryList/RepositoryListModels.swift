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
            var repos: [ReactiveDataStore<Repository>]
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
                
                init(_ repositoryStore: ReactiveDataStore<Repository>) {
                    
                    repositoryStore.store
                        .map({ State($0) })
                        .bind(to: state)
                        .disposed(by: disposeBag)
                    
                    self.identifier = repositoryStore.value.id
                }
            }
            
            var repoCellViewModels: [CellViewModel]
            
            init(_ repositries: [ReactiveDataStore<Repository>]) {
                self.repoCellViewModels = repositries.map({ CellViewModel($0) })
            }
        }
    }
    
    struct RepositoryShow {
        
        struct Request {
            var repoID: Int
        }
        
        struct Response {
            
        }
        
        struct ViewModel {
            
        }
    }
}
