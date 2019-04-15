import RxSwift
import RxCocoa
import RxOptional

protocol RepositoryShowInteractorLogic: class {
    
    var loadRepository: PublishRelay<RepositoryShowModel.Request> { get }
}

class RepositoryShowInteractor: RepositoryShowInteractorLogic  {
    
    var loadRepository: PublishRelay<RepositoryShowModel.Request> = .init()
    
    func bind(to presenter: RepositoryShowPresenterLogic) -> Disposable {
        
        let disposeable = loadRepository
            .map({ $0.id })
            .flatMap({ RepositoryShowWorker.loadCachedRepository($0) })
            .map({ RepositoryShowModel.Response(repo: $0) })
            .bind(to: presenter.repositoryResponse)
        
        return Disposables.create([disposeable])
    }
}
