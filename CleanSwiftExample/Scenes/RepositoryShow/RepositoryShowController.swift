import AsyncDisplayKit
import RxSwift
import RxCocoa
import ReactorKit

protocol RepositoryShowDisplayLogic: class {
    
    var displayRepositoryShowState: PublishRelay<RepositoryShowModels.RepositoryShowComponent.ViewModel> { get }
    var displayDissmiss: PublishRelay<RepositoryShowModels.RepositoryShowDismiss.ViewModel> { get }
}

class RepositoryShowController: ASViewController<RepoShowContainerNode> & RepositoryShowDisplayLogic {
    
    var interactor: RepositoryShowInteractorLogic?
    var router: RepositoryShowRouterLogic?
    
    var displayRepositoryShowState:
        PublishRelay<RepositoryShowModels.RepositoryShowComponent.ViewModel> = .init()
    var displayDissmiss:
        PublishRelay<RepositoryShowModels.RepositoryShowDismiss.ViewModel> = .init()
    
    var disposeBag = DisposeBag()
    private var identifier: Int
    
    init(_ id: Int) {
        self.identifier = id
        super.init(node: .init(id: id))
        self.configureVIPCycle()
        self.binding()
        self.interactor?.loadRepository.accept(.init(id: id))
    }
    
    func configureVIPCycle() {
        let viewController = self
        let interactor = RepositoryShowInteractor.init()
        let presenter = RepositoryShowPresenter.init()
        let router = RepositoryShowRouter()
        
        interactor.bind(to: presenter).disposed(by: disposeBag)
        presenter.bind(to: viewController).disposed(by: disposeBag)
        router.bind(to: viewController).disposed(by: disposeBag)
        
        viewController.interactor = interactor
        viewController.router = router
    }
    
    func binding() {
        guard let interactor = self.interactor,
            let router = self.router else {
            return
        }
        
        self.node.bind(state: self.displayRepositoryShowState.asObservable())
        self.node.bind(action: interactor)
        
        self.displayDissmiss
            .map({ _ in return })
            .bind(to: router.dismiss)
            .disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
