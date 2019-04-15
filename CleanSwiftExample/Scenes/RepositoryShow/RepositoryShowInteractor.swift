import RxSwift
import RxCocoa
import RxOptional

protocol RepositoryShowInteractorLogic: class {
    
    var loadRepository: PublishRelay<RepositoryShowModels.RepositoryShowComponent.Request> { get }
    var didTapDismissButton: PublishRelay<RepositoryShowModels.RepositoryShowDismiss.Request> { get }
    var didTapPin: PublishRelay<RepositoryShowModels.RepositoryShowComponent.Request> { get }
}

class RepositoryShowInteractor: RepositoryShowInteractorLogic  {
    
    public var loadRepository: PublishRelay<RepositoryShowModels.RepositoryShowComponent.Request> = .init()
    public var didTapDismissButton: PublishRelay<RepositoryShowModels.RepositoryShowDismiss.Request> = .init()
    public var didTapPin: PublishRelay<RepositoryShowModels.RepositoryShowComponent.Request> = .init()
    
    private let worker = RepositoryShowWorker()
    
    func bind(to presenter: RepositoryShowPresenterLogic) -> Disposable {
        
        let loadRepoDisposable = loadRepository
            .flatMap({ [unowned self] request in
                return self.worker.loadCachedRepository(request.id)
            })
            .map({ RepositoryShowModels.RepositoryShowComponent.Response(repo: $0) })
            .bind(to: presenter.createRepositoryShowViewModel)
        
        let dismissDisposable = didTapDismissButton
            .map({ _ in return RepositoryShowModels.RepositoryShowDismiss.Response() })
            .bind(to: presenter.dismissRepositoryShow)
        
        let didTapPinDisposable = didTapPin
            .flatMap({ [unowned self] request in
                return self.worker.togglePin(request.id)
            })
            .map({ RepositoryShowModels.RepositoryShowComponent.Response(repo: $0) })
            .bind(to: presenter.createRepositoryShowViewModel)
        
        return Disposables.create([loadRepoDisposable,
                                   dismissDisposable,
                                   didTapPinDisposable])
    }
}
