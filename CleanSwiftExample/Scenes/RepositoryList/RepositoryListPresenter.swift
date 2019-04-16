import RxSwift
import RxCocoa

protocol RepositoryListPresenterLogic: class {
    
    var loadRelay: PublishRelay<RepositoryListModels.RepositorySequence.Response> { get }
    var errorRelay: PublishRelay<Error?> { get }
    var presentRepositoryShow: PublishRelay<RepositoryListModels.RepositoryShow.Response> { get }
    var updateRepository: PublishRelay<RepositoryListModels.RepositoryCell.Response> { get }
}

class RepositoryListPresenter: RepositoryListPresenterLogic {
    
    public var loadRelay: PublishRelay<RepositoryListModels.RepositorySequence.Response> = .init()
    public var presentRepositoryShow: PublishRelay<RepositoryListModels.RepositoryShow.Response> = .init()
    public var updateRepository: PublishRelay<RepositoryListModels.RepositoryCell.Response> = .init()
    
    public var errorRelay: PublishRelay<Error?> = .init()
    
    func bind(to viewController: RepositoryListDisplayLogic) -> Disposable {
        
        let loadDisposable =
            loadRelay
                .map({ RepositoryListModels.RepositorySequence.ViewModel.init($0.repos) })
                .bind(to: viewController.displayItemsRelay)
        
        let errorDisposable =
            errorRelay
                .bind(to: viewController.displayErrorRelay)
        
        let presentRepoShowDisposable =
            presentRepositoryShow
                .map({ RepositoryListModels.RepositoryShow.ViewModel.init(repoID: $0.repoID) })
                .bind(to: viewController.displayPresentToRepositoryShow)
        
        let updateRepositoryDisposable =
            updateRepository
                .map({ .init($0.repository) })
                .bind(to: viewController.updateRepository)
        
        return Disposables.create([loadDisposable,
                                   errorDisposable,
                                   presentRepoShowDisposable,
                                   updateRepositoryDisposable])
    }
}
