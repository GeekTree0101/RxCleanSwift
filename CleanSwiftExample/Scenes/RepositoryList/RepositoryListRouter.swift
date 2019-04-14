import RxSwift
import RxCocoa

protocol RepositoryListRouterLogic: class {
    
    var presentToRepositoryShowRelay: PublishRelay<RepoReactor> { get }
}

class RepositoryListRouter: RepositoryListRouterLogic {
    
    var presentToRepositoryShowRelay: PublishRelay<RepoReactor> = .init()
    
    func bind(to viewController: RepositoryListController) -> Disposable {
        
        let presentToRepoShowDisposable =
            presentToRepositoryShowRelay
                .subscribe(onNext: { [weak viewController] reactor in
                    viewController?.present(RepositoryShowController(reactor: reactor),
                                            animated: true,
                                            completion: nil)
                })
        
        return Disposables.create([presentToRepoShowDisposable])
    }
}
