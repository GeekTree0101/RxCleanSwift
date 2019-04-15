import RxSwift
import RxCocoa
import RxOptional

protocol RepositoryShowInteractorLogic: class {
    
    var loadRepository: PublishRelay<RepositoryShowModels.RepositoryShowComponent.Request> { get }
    var didTapDismissButton: PublishRelay<RepositoryShowModels.RepositoryShowDismiss.Request> { get }
}

class RepositoryShowInteractor: RepositoryShowInteractorLogic  {
    
    public var loadRepository: PublishRelay<RepositoryShowModels.RepositoryShowComponent.Request> = .init()
    public var didTapDismissButton: PublishRelay<RepositoryShowModels.RepositoryShowDismiss.Request> = .init()
    
    private let worker = RepositoryShowWorker()
    
    func bind(to presenter: RepositoryShowPresenterLogic) -> Disposable {
        
        let loadRepoDisposable = loadRepository
            .flatMap({ [unowned self] request in
                return self.worker.loadCachedRepository(request.id)
            })
            .map({ RepositoryShowModels.RepositoryShowComponent.Response(repo: $0) })
            .bind(to: presenter.repositoryResponse)
        
        let dismissDisposable = didTapDismissButton
            .map({ _ in return RepositoryShowModels.RepositoryShowDismiss.Response() })
            .bind(to: presenter.dismissRepositoryShow)
        
        return Disposables.create([loadRepoDisposable, dismissDisposable])
    }
}
