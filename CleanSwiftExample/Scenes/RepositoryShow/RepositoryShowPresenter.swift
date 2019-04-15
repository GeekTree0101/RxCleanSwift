import RxSwift
import RxCocoa

protocol RepositoryShowPresenterLogic: class {
    
    var createRepositoryShowViewModel: PublishRelay<RepositoryShowModels.RepositoryShowComponent.Response> { get }
    var dismissRepositoryShow: PublishRelay<RepositoryShowModels.RepositoryShowDismiss.Response> { get }
}

class RepositoryShowPresenter: RepositoryShowPresenterLogic {
    
    var createRepositoryShowViewModel: PublishRelay<RepositoryShowModels.RepositoryShowComponent.Response> = .init()
    var dismissRepositoryShow: PublishRelay<RepositoryShowModels.RepositoryShowDismiss.Response> = .init()
    
    func bind(to viewController: RepositoryShowDisplayLogic) -> Disposable {
        
        let repositoryDisposable = createRepositoryShowViewModel
            .map({ RepositoryShowModels.RepositoryShowComponent.ViewModel($0.repo) })
            .bind(to: viewController.displayRepositoryShowState)
        
        let dismissDisposable = dismissRepositoryShow
            .map({ _ in  return RepositoryShowModels.RepositoryShowDismiss.ViewModel() })
            .bind(to: viewController.displayDissmiss)
        
        
        return Disposables.create([repositoryDisposable,
                                   dismissDisposable])
    }
}
