import RxSwift
import RxCocoa

protocol RepositoryListRouterLogic: class {
    
    var presentToRepositoryShowRelay: PublishRelay<Int> { get }
}

class RepositoryListRouter: RepositoryListRouterLogic {
    
    var presentToRepositoryShowRelay: PublishRelay<Int> = .init()
    
    func bind(to viewController: RepositoryListController) -> Disposable {
        
        let presentToRepoShowDisposable =
            presentToRepositoryShowRelay
                .subscribe(onNext: { [weak viewController] id in
                    let vc = RepositoryShowController(id)
                    viewController?.present(vc,
                                            animated: true,
                                            completion: nil)
                })
        
        return Disposables.create([presentToRepoShowDisposable])
    }
}
