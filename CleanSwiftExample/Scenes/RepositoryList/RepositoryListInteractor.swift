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
    
    private let worker = RepositoryListWorker(api: RepoAPI.init())
    
    func bind(to presenter: RepositoryListPresenterLogic) -> Disposable {
        
        let sharedLoadMore =
            loadMoreRelay
                .flatMap({ [unowned self] request in
                    return self.worker.load(since: request.since)
                })
                .map({ RepositoryListModels.RepositorySequence.Response(repos: $0) })
                .share()
        
        let errorDisposable =
            sharedLoadMore
                .materialize()
                .map { event -> Error? in
                    switch event {
                    case .error(let error):
                        return error
                    default:
                        return nil
                    }
                }
                .filterNil()
                .bind(to: presenter.errorRelay)
        
        let loadDisposable = sharedLoadMore
            .materialize()
            .map { event -> RepositoryListModels.RepositorySequence.Response? in
                switch event {
                case .next(let response):
                    return response
                default:
                    return nil
                }
            }
            .filterNil()
            .bind(to: presenter.loadRelay)
        
        let repoShowDisposable =
            didTapRepositoryCell
                .map({ RepositoryListModels.RepositoryShow.Response(repoID: $0.repoID) })
                .bind(to: presenter.presentRepositoryShow)
        
        let updateRepositoryDisposable =
            updateRepository
                .map({ .init(repository: $0.repository) })
                .bind(to: presenter.updateRepository)
        
        return Disposables.create([errorDisposable,
                                   loadDisposable,
                                   repoShowDisposable,
                                   updateRepositoryDisposable])
    }
}
