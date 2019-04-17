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
    
    // Interactor: It receives user actions from View Controller
    public var loadRepository: PublishRelay<RepositoryShowModels.Show.Request> = .init()
    public var didTapDismissButton: PublishRelay<RepositoryShowModels.Dismiss.Request> = .init()
    public var didTapPin: PublishRelay<RepositoryShowModels.Show.Request> = .init()
    
    // Worker: Extract business logic from view controllers into interactors.
    public var commonWorker = RepositoryCommonWorker.init()
    public var showWorker = RepositoryShowWorker()
    
    // DataSotre: It is cached data and pass to other controller by router
    public var repositoryStore: ReactiveDataStore<Repository>?
    
    private var repositoryIdentifier: Int {
        return self.repositoryStore?.value.id ?? -1
    }
    
    func bind(to presenter: RepositoryShowPresenterLogic) -> Disposable {
        
        let loadRepoDisposable = loadRepository
            .flatMap({ [unowned self] _ -> Single<Repository> in
                return self.commonWorker.loadCachedRepository(self.repositoryIdentifier)
            })
            .map({ RepositoryShowModels.Show.Response.init(repo: $0) })
            .bind(to: presenter.createRepositoryShowViewModel)
        
        let dismissDisposable = didTapDismissButton
            .flatMap({ [unowned self] _ -> Single<Repository> in
                return self.commonWorker.loadCachedRepository(self.repositoryIdentifier)
            })
            .map({ [unowned self] repo in
                self.repositoryStore?.update(repo)
                return RepositoryShowModels.Dismiss.Response()
            })
            .bind(to: presenter.dismissRepositoryShow)
        
        let didTapPinDisposable = didTapPin
            .flatMap({ [unowned self] _ -> Single<Repository> in
                return self.showWorker.togglePin(self.repositoryIdentifier)
            })
            .map({ RepositoryShowModels.Show.Response.init(repo: $0) })
            .bind(to: presenter.createRepositoryShowViewModel)
        
        return Disposables.create([loadRepoDisposable,
                                   dismissDisposable,
                                   didTapPinDisposable])
    }
}
