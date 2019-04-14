import RxSwift
import RxCocoa

protocol RepositoryListPresenterLogic: class {
    
    var loadRelay: PublishRelay<RepositoryListModel.Response> { get }
    var errorRelay: PublishRelay<Error?> { get }
}

class RepositoryListPresenter: RepositoryListPresenterLogic {
    
    public var loadRelay: PublishRelay<RepositoryListModel.Response> = .init()
    public var errorRelay: PublishRelay<Error?> = .init()
    
    func bind(to viewController: RepositoryListDisplayLogic) -> Disposable {
        
        let loadDisposable =
            loadRelay
                .map({ .init(repoReactors: $0.repos.map({ RepoReactor($0) })) })
                .bind(to: viewController.displayItemsRelay)
        
        let errorDisposable =
            errorRelay
                .bind(to: viewController.displayErrorRelay)
        
        return Disposables.create([loadDisposable, errorDisposable])
    }
}
