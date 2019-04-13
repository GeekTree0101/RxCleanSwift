import ReactorKit

class RepoReactor: Reactor {
    
    enum Action {
        case didTapPin
    }
    
    struct State {
        var profileURL: URL?
        var title: String?
        var desc: String?
        var isPinned: Bool = false
    }
    
    var initialState: RepoReactor.State
    
    init(_ repo: Repository) {
        initialState = State.init(profileURL: repo.user?.profileURL,
                                  title: repo.user?.username,
                                  desc: repo.desc,
                                  isPinned: false)
    }
    
    func reduce(state: RepoReactor.State,
                mutation: RepoReactor.Action) -> RepoReactor.State {
        var newState = state
        
        switch mutation {
        case .didTapPin:
            newState.isPinned = !state.isPinned
        }
        
        return newState
    }
}
