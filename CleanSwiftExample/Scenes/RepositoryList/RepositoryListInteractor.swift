import RxSwift
import RxCocoa
import RxOptional

protocol RepositoryListInteractorLogic: class {
    
    var loadMoreRelay: PublishRelay<RepositoryListModel.Request> { get }
}

class RepositoryListInteractor: RepositoryListInteractorLogic  {
    
    public var loadMoreRelay: PublishRelay<RepositoryListModel.Request> = .init()
    
    func bind(to presenter: RepositoryListPresenterLogic) -> Disposable {
        
        let sharedLoadMore =
            loadMoreRelay
                .flatMap({ RepositoryListWorker.load(since: $0.since) })
                .map({ RepositoryListModel.Response.init(repos: $0) })
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
            .map { event -> RepositoryListModel.Response? in
                switch event {
                case .next(let response):
                    return response
                default:
                    return nil
                }
            }
            .filterNil()
            .bind(to: presenter.loadRelay)
        
        return Disposables.create([errorDisposable, loadDisposable])
    }
}
