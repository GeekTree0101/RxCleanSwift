import RxSwift
import RxCocoa

protocol RepositoryShowPresenterLogic: class {
    
    var createRepositoryShowViewModel: PublishRelay<RepositoryShowModels.Show.Response> { get }
    var dismissRepositoryShow: PublishRelay<RepositoryShowModels.Dismiss.Response> { get }
}

class RepositoryShowPresenter: RepositoryShowPresenterLogic {
    
    var createRepositoryShowViewModel: PublishRelay<RepositoryShowModels.Show.Response> = .init()
    var dismissRepositoryShow: PublishRelay<RepositoryShowModels.Dismiss.Response> = .init()
    
    func bind(to viewController: RepositoryShowDisplayLogic) -> Disposable {
        
        let repositoryDisposable = createRepositoryShowViewModel
            .map({ RepositoryShowModels.Show.ViewModel($0.repo) })
            .bind(to: viewController.displayRepositoryShowState)
        
        let dismissDisposable = dismissRepositoryShow
            .map({ _ in return RepositoryShowModels.Dismiss.ViewModel() })
            .bind(to: viewController.displayDissmiss)
        
        return Disposables.create([repositoryDisposable,
                                   dismissDisposable])
    }
}
