import RxSwift
import RxCocoa
import RxOptional

protocol RepositoryShowInteractorLogic: class {
    
    var loadRepository: PublishRelay<RepositoryShowModels.Show.Request> { get }
    var didTapDismissButton: PublishRelay<RepositoryShowModels.Dismiss.Request> { get }
    var didTapPin: PublishRelay<RepositoryShowModels.Show.Request> { get }
}

class RepositoryShowInteractor: RepositoryShowInteractorLogic  {
    
    public var loadRepository: PublishRelay<RepositoryShowModels.Show.Request> = .init()
    public var didTapDismissButton: PublishRelay<RepositoryShowModels.Dismiss.Request> = .init()
    public var didTapPin: PublishRelay<RepositoryShowModels.Show.Request> = .init()
    
    public let worker = RepositoryShowWorker()
    
    func bind(to presenter: RepositoryShowPresenterLogic) -> Disposable {
        
        let loadRepoDisposable = loadRepository
            .flatMap({ [unowned self] request in
                return self.worker.loadCachedRepository(request.id)
            })
            .map({ RepositoryShowModels.Show.Response(repo: $0) })
            .bind(to: presenter.createRepositoryShowViewModel)
        
        let dismissDisposable = didTapDismissButton
            .flatMap({ [unowned self] request in
                return self.worker.loadCachedRepository(request.id)
            })
            .map({ RepositoryShowModels.Dismiss.Response(repo: $0) })
            .bind(to: presenter.dismissRepositoryShow)
        
        let didTapPinDisposable = didTapPin
            .flatMap({ [unowned self] request in
                return self.worker.togglePin(request.id)
            })
            .map({ RepositoryShowModels.Show.Response(repo: $0) })
            .bind(to: presenter.createRepositoryShowViewModel)
        
        return Disposables.create([loadRepoDisposable,
                                   dismissDisposable,
                                   didTapPinDisposable])
    }
}
