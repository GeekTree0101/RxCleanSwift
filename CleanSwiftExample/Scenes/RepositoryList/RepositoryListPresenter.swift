import RxSwift
import RxCocoa

protocol RepositoryListPresenterLogic: class {
    
    var loadRelay: PublishRelay<RepositoryListModel.Response> { get }
    var errorRelay: PublishRelay<Error?> { get }
}

class RepositoryListPresenter: RepositoryListPresenterLogic {
    
    public var loadRelay: PublishRelay<RepositoryListModel.Response> = .init()
    public var errorRelay: PublishRelay<Error?> = .init()
    
    private let disposeBag = DisposeBag()
    
    init(_ viewController: RepositoryListDisplayLogic) {
        
        loadRelay
            .map({ .init(repoReactors: $0.repos.map({ RepoReactor($0) })) })
            .bind(to: viewController.displayItemsRelay)
            .disposed(by: disposeBag)
        
        errorRelay
            .bind(to: viewController.displayErrorRelay)
            .disposed(by: disposeBag)
    }
}
