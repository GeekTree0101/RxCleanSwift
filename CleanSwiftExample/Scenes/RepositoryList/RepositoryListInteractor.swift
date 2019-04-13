import RxSwift

protocol RepositoryListInteractorLogic: class {
    
    func loadMore(_ request: RepositoryListModel.Request)
}

class RepositoryListInteractor: RepositoryListInteractorLogic  {
    
    var presenter: RepositoryListPresenterLogic?
    private let worker = RepositoryListWorker.init()
    
    func loadMore(_ request: RepositoryListModel.Request) {
        _ = worker.load(since: request.since)
            .map({ RepositoryListModel.Response.init(repos: $0) })
            .subscribe(onSuccess: { [weak self] response in
                self?.presenter?.load(response)
            }, onError: { [weak self] error in
                self?.presenter?.error(error)
            })
    }
}
