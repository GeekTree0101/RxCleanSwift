import RxSwift
import RxCocoa

protocol RepositoryListPresenterLogic: class {
    
    var presentLoadRelay: PublishRelay<RepositoryListModels.RepositorySequence.Response> { get }
    var presentErrorRelay: PublishRelay<Error?> { get }
    var presentRepositoryShow: PublishRelay<RepositoryListModels.RepositoryShow.Response> { get }
}

class RepositoryListPresenter: RepositoryListPresenterLogic {
    
    public var presentLoadRelay: PublishRelay<RepositoryListModels.RepositorySequence.Response> = .init()
    public var presentErrorRelay: PublishRelay<Error?> = .init()
    public var presentRepositoryShow: PublishRelay<RepositoryListModels.RepositoryShow.Response> = .init()
    
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
                .map({ _ in return .init() })
                .bind(to: viewController.displayPresentToRepositoryShow)
        
        return Disposables.create([loadDisposable,
                                   errorDisposable,
                                   presentRepoShowDisposable])
    }
}
