import RxSwift
import RxCocoa

protocol RepositoryListPresenterLogic: class {
    
    var presentLoadRelay: PublishRelay<RepositoryListModels.RepositorySequence.Response> { get }
    var presentErrorRelay: PublishRelay<Error?> { get }
    var presentRepositoryShow: PublishRelay<RepositoryListModels.RepositoryShow.Response> { get }
    var presentUpdateRepository: PublishRelay<RepositoryListModels.RepositoryCell.Response> { get }
}

class RepositoryListPresenter: RepositoryListPresenterLogic {
    
    public var presentLoadRelay: PublishRelay<RepositoryListModels.RepositorySequence.Response> = .init()
    public var presentErrorRelay: PublishRelay<Error?> = .init()
    public var presentRepositoryShow: PublishRelay<RepositoryListModels.RepositoryShow.Response> = .init()
    public var presentUpdateRepository: PublishRelay<RepositoryListModels.RepositoryCell.Response> = .init()
    
    func bind(to viewController: RepositoryListDisplayLogic) -> Disposable {
        
        let loadDisposable =
            presentLoadRelay
                .map({ RepositoryListModels.RepositorySequence.ViewModel.init($0.repos) })
                .bind(to: viewController.displayItemsRelay)
        
        let errorDisposable =
            presentErrorRelay
                .bind(to: viewController.displayErrorRelay)
        
        let presentRepoShowDisposable =
            presentRepositoryShow
                .map({ RepositoryListModels.RepositoryShow.ViewModel.init(repoID: $0.repoID) })
                .bind(to: viewController.displayPresentToRepositoryShow)
        
        let updateRepositoryDisposable =
            presentUpdateRepository
                .map({ .init($0.repository) })
                .bind(to: viewController.displayUpdateRepositoryCellState)
        
        return Disposables.create([loadDisposable,
                                   errorDisposable,
                                   presentRepoShowDisposable,
                                   updateRepositoryDisposable])
    }
}
