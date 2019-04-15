import ReactorKit
import RxSwift

class RepoReactor: Reactor {
    
    enum Action {
        case didTapPin
    }
    
    struct State {
        var profileURL: URL?
        var title: String?
        var desc: String?
        var isPinned: Bool
    }
    
    var id: Int
    var initialState: RepoReactor.State
    
    private var disposeBag = DisposeBag()
    
    init(_ repo: Repository) {
        self.id = repo.id
        initialState = State.init(profileURL: repo.user?.profileURL,
                                  title: repo.user?.username,
                                  desc: repo.desc,
                                  isPinned: repo.isPinned)
        
        DataProvider.shared.observe(.repository(repo.id), type: Repository.self)
            .withLatestFrom(self.state) { ($0, $1) }
            .filter({ $0.0.isPinned != $0.1.isPinned })
            .map({ _ in return Action.didTapPin })
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
        }
        
        return newState
    }
}
