import ReactorKit
import RxSwift

class RepoReactor: Reactor {
    
    enum Action {
        case didTapPin
        case updateRepository(Repository)
    }
    
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
    
    var id: Int
    var initialState: RepoReactor.State
    
    private var disposeBag = DisposeBag()
    
    init(_ repo: Repository) {
        self.id = repo.id
        initialState = State(repo)
        
        DataProvider.shared
            .observe(.repository(repo.id), type: Repository.self)
            .map({ Action.updateRepository($0) })
            .bind(to: self.action)
            .disposed(by: disposeBag)
    }
    
    func reduce(state: RepoReactor.State, mutation: Action) -> RepoReactor.State {
        var newState = state
        
        switch mutation {
        case .didTapPin:
            // NOTE: cache updated repository
            if var repo = DataProvider.shared.load(.repository(self.id), type: Repository.self) {
                repo.isPinned = !state.isPinned
                DataProvider.shared.save(.repository(self.id), model: repo)
            }
            
            newState.isPinned = !state.isPinned
        case .updateRepository(let repo):
            newState = State(repo)
        }
        
        return newState
    }
}
