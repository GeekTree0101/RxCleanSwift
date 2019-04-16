import RxSwift
import RxCocoa

protocol RepositoryShowRouterLogic: class {
    
    var dismiss: PublishRelay<RepositoryShowModels.Dismiss.ViewModel> { get }
}

class RepositoryShowRouter: RepositoryShowRouterLogic {
    
    var dismiss: PublishRelay<RepositoryShowModels.Dismiss.ViewModel> = .init()
    
    func bind(to viewController: RepositoryShowController) -> Disposable {
        
        let disposeable = dismiss.subscribe(onNext: { [weak viewController] _ in
            viewController?.dismiss(animated: true, completion: nil)
        })
        
        return Disposables.create([disposeable])
    }
}
