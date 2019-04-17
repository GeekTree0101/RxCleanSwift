import RxSwift
import RxCocoa

protocol RepositoryListRouterLogic: class {
    
    var presentToRepositoryShowRelay: PublishRelay<Void> { get }
}

protocol RepositoryListDataPassing: class {
    
    var dataStore: RepositoryListDataSotre? { get set }
}

class RepositoryListRouter: RepositoryListRouterLogic & RepositoryListDataPassing {
    
    var presentToRepositoryShowRelay: PublishRelay<Void> = .init()
    
    var dataStore: RepositoryListDataSotre?
    
    func bind(to viewController: RepositoryListController) -> Disposable {
        
        let presentToRepoShowDisposable =
            presentToRepositoryShowRelay
                .subscribe(onNext: { [weak self, weak viewController] _ in
                    guard let targetId = self?.dataStore?.presentRepositoryShowIdentifier,
                        let repositoryStore = self?.dataStore?.repositoryStores
                            .filter({ $0.value.id == targetId }).first else { return }
                    
                    let vc = RepositoryShowController()
                    vc.router?.dataStore?.repositoryStore = repositoryStore
                    
                    viewController?.present(vc,
                                            animated: true,
                                            completion: nil)
                })
        
        return Disposables.create([presentToRepoShowDisposable])
    }
}
