import RxSwift
import RxCocoa
import RxOptional

protocol RepositoryShowInteractorLogic: class {
    
    var loadRepository: PublishRelay<RepositoryShowModel.Request> { get }
}

class RepositoryShowInteractor: RepositoryShowInteractorLogic  {
    
    var loadRepository: PublishRelay<RepositoryShowModel.Request> = .init()
    private let worker = RepositoryShowWorker()
    
    func bind(to presenter: RepositoryShowPresenterLogic) -> Disposable {
        
        let disposeable = loadRepository
            .flatMap({ [unowned self] request in
                return self.worker.loadCachedRepository(request.id)
            })
            .map({ RepositoryShowModel.Response(repo: $0) })
            .bind(to: presenter.repositoryResponse)
        
        return Disposables.create([disposeable])
    }
}
