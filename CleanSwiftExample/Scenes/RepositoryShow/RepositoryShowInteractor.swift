import RxSwift
import RxCocoa
import RxOptional

protocol RepositoryShowInteractorLogic: class {
    
    var loadRepository: PublishRelay<RepositoryShowModels.Show.Request> { get }
    var didTapDismissButton: PublishRelay<RepositoryShowModels.Dismiss.Request> { get }
    var didTapPin: PublishRelay<RepositoryShowModels.Show.Request> { get }
}

protocol RepositoryShowDataStore: class {
    
    var repositoryStore: ReactiveDataStore<Repository>? { get set }
}

class RepositoryShowInteractor: RepositoryShowInteractorLogic & RepositoryShowDataStore {
    
    public var loadRepository: PublishRelay<RepositoryShowModels.Show.Request> = .init()
    public var didTapDismissButton: PublishRelay<RepositoryShowModels.Dismiss.Request> = .init()
    public var didTapPin: PublishRelay<RepositoryShowModels.Show.Request> = .init()
    
    public var worker = RepositoryShowWorker()
    
    public var repositoryStore: ReactiveDataStore<Repository>?
    
    func bind(to presenter: RepositoryShowPresenterLogic) -> Disposable {
        
        let loadRepoDisposable = loadRepository
            .flatMap({ [unowned self] _ -> Single<Repository> in
                let id = self.repositoryStore?.value.id ?? -1
                return self.worker.loadCachedRepository(id)
            })
            .map({ RepositoryShowModels.Show.Response.init(repo: $0) })
            .bind(to: presenter.createRepositoryShowViewModel)
        
        let dismissDisposable = didTapDismissButton
            .flatMap({ [unowned self] _ -> Single<Repository> in
                let id = self.repositoryStore?.value.id ?? -1
                return self.worker.loadCachedRepository(id)
            })
            .map({ [unowned self] repo in
                self.repositoryStore?.update(repo)
                return RepositoryShowModels.Dismiss.Response()
            })
            .bind(to: presenter.dismissRepositoryShow)
        
        let didTapPinDisposable = didTapPin
            .flatMap({ [unowned self] request -> Single<Repository> in
                let id = self.repositoryStore?.value.id ?? -1
                return self.worker.togglePin(id)
            })
            .map({ RepositoryShowModels.Show.Response.init(repo: $0) })
            .bind(to: presenter.createRepositoryShowViewModel)
        
        return Disposables.create([loadRepoDisposable,
                                   dismissDisposable,
                                   didTapPinDisposable])
    }
}
