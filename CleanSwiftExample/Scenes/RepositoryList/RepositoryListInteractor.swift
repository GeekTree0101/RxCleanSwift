import RxSwift
import RxCocoa
import RxOptional

protocol RepositoryListInteractorLogic: class {
    
    var loadMoreRelay: PublishRelay<RepositoryListModel.RepositorySequence.Request> { get }
    var didTapRepositoryCell: PublishRelay<RepositoryListModel.RepositoryShow.Request> { get }
}

class RepositoryListInteractor: RepositoryListInteractorLogic  {
    
    public var loadMoreRelay: PublishRelay<RepositoryListModel.RepositorySequence.Request> = .init()
    public var didTapRepositoryCell: PublishRelay<RepositoryListModel.RepositoryShow.Request> = .init()
    
    private let worker = RepositoryListWorker(api: RepoAPI.init())
    
    func bind(to presenter: RepositoryListPresenterLogic) -> Disposable {
        
        let sharedLoadMore =
            loadMoreRelay
                .flatMap({ [unowned self] request in
                    return self.worker.load(since: request.since)
                })
                .map({ RepositoryListModel.RepositorySequence.Response(repos: $0) })
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
            .map { event -> RepositoryListModel.RepositorySequence.Response? in
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
                .map({ RepositoryListModel.RepositoryShow.Response(repoID: $0.repoID) })
                .bind(to: presenter.presentRepositoryShow)
        
        return Disposables.create([errorDisposable,
                                   loadDisposable,
                                   repoShowDisposable])
    }
}
