import RxSwift
import RxCocoa

protocol RepositoryShowRouterLogic: class {
    
    var dismiss: PublishRelay<Void> { get }
}

class RepositoryShowRouter: RepositoryShowRouterLogic {
    
    var dismiss: PublishRelay<Void> = .init()
    
    func bind(to viewController: RepositoryShowController) -> Disposable {
        
        let disposeable = dismiss.subscribe(onNext: { [weak viewController] _ in
            viewController?.dismiss(animated: true, completion: nil)
        })
        
        return Disposables.create([disposeable])
    }
}
