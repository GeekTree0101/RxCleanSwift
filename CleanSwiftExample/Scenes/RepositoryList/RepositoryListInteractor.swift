import RxSwift
import RxCocoa
import RxOptional

protocol RepositoryListInteractorLogic: class {
    
    var loadMoreRelay: PublishRelay<RepositoryListModels.RepositorySequence.Request> { get }
    var didTapRepositoryCell: PublishRelay<RepositoryListModels.RepositoryShow.Request> { get }
}

protocol RepositoryListDataSotre: class {
    
    var repositoryStores: [ReactiveDataStore<Repository>] { get set }
    var displayTargetIdentifier: Int? { get set }
}

class RepositoryListInteractor: RepositoryListInteractorLogic & RepositoryListDataSotre {
    
    public var loadMoreRelay: PublishRelay<RepositoryListModels.RepositorySequence.Request> = .init()
    public var didTapRepositoryCell: PublishRelay<RepositoryListModels.RepositoryShow.Request> = .init()
    
    public let worker = RepositoryListWorker(api: RepoAPI.init())
    
    public var repositoryStores: [ReactiveDataStore<Repository>] = []
    public var displayTargetIdentifier: Int?
    
    func bind(to presenter: RepositoryListPresenterLogic) -> Disposable {
        
        let sharedLoadMore = loadMoreRelay
            .flatMap({ [unowned self] request in
                return self.worker.loadRepositoryList(since: request.since)
            })
            .map({ [unowned self] repositories -> [ReactiveDataStore<Repository>] in
                let repoStores = self.worker.convertToRepositoryDataStore(repositories)
                self.repositoryStores.append(contentsOf: repoStores)
                return repoStores
            })
            .map({ RepositoryListModels.RepositorySequence.Response(repos: $0) })
            .share()
        
        let errorDisposable = sharedLoadMore
            .onError()
            .bind(to: presenter.presentErrorRelay)
        
        let loadDisposable = sharedLoadMore
            .onSuccess()
            .bind(to: presenter.presentLoadRelay)
        
        let repoShowDisposable = didTapRepositoryCell
            .map({ [unowned self] request in
                self.displayTargetIdentifier = request.repoID
                return RepositoryListModels.RepositoryShow.Response.init()
            })
            .bind(to: presenter.presentRepositoryShow)
        
        return Disposables.create([errorDisposable,
                                   loadDisposable,
                                   repoShowDisposable])
    }
}
