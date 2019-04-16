import RxSwift
import RxCocoa
import RxOptional

protocol RepositoryListInteractorLogic: class {
    
    var loadMoreRelay: PublishRelay<RepositoryListModels.RepositorySequence.Request> { get }
    var didTapRepositoryCell: PublishRelay<RepositoryListModels.RepositoryShow.Request> { get }
    var updateRepository: PublishRelay<RepositoryListModels.RepositoryCell.Request> { get }
}

class RepositoryListInteractor: RepositoryListInteractorLogic  {
    
    public var loadMoreRelay: PublishRelay<RepositoryListModels.RepositorySequence.Request> = .init()
    public var didTapRepositoryCell: PublishRelay<RepositoryListModels.RepositoryShow.Request> = .init()
    public var updateRepository: PublishRelay<RepositoryListModels.RepositoryCell.Request> = .init()
    
    public let worker = RepositoryListWorker(api: RepoAPI.init())
    
    func bind(to presenter: RepositoryListPresenterLogic) -> Disposable {
        
        let sharedLoadMore = loadMoreRelay
            .flatMap({ [unowned self] request in
                return self.worker.loadRepositoryList(since: request.since)
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
            .map({ .init(repoID: $0.repoID) })
            .bind(to: presenter.presentRepositoryShow)
        
        let updateRepositoryDisposable = updateRepository
            .map({ .init(repository: $0.repository) })
            .bind(to: presenter.presentUpdateRepository)
        
        return Disposables.create([errorDisposable,
                                   loadDisposable,
                                   repoShowDisposable,
                                   updateRepositoryDisposable])
    }
}
