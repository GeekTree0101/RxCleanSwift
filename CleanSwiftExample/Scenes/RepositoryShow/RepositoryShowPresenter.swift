import RxSwift
import RxCocoa

protocol RepositoryShowPresenterLogic: class {
    
    var repositoryResponse: PublishRelay<RepositoryShowModel.Response> { get }
}

class RepositoryShowPresenter: RepositoryShowPresenterLogic {
    
    var repositoryResponse: PublishRelay<RepositoryShowModel.Response> = .init()
    
    func bind(to viewController: RepositoryShowDisplayLogic) -> Disposable {
        
        let disposable = repositoryResponse
            .map({ RepositoryShowModel.ViewModel(repoReactor: .init($0.repo)) })
            .bind(to: viewController.displayShowReactor)
        
        return Disposables.create([disposable])
    }
}
