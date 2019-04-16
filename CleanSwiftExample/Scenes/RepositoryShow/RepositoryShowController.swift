import AsyncDisplayKit
import RxSwift
import RxCocoa

protocol RepositoryShowDisplayLogic: class {
    
    var displayRepositoryShowState: PublishRelay<RepositoryShowModels.Show.ViewModel> { get }
    var displayDissmiss: PublishRelay<RepositoryShowModels.Dismiss.ViewModel> { get }
}

class RepositoryShowController: ASViewController<RepoShowContainerNode> & RepositoryShowDisplayLogic {
    
    var interactor: RepositoryShowInteractorLogic?
    var router: (RepositoryShowRouterLogic & RepositoryShowDataPassing)?
    
    var displayRepositoryShowState: PublishRelay<RepositoryShowModels.Show.ViewModel> = .init()
    var displayDissmiss: PublishRelay<RepositoryShowModels.Dismiss.ViewModel> = .init()
    
    var disposeBag = DisposeBag()
    private var identifier: Int
    
    init(_ id: Int) {
        self.identifier = id
        super.init(node: .init(id: id))
        self.configureVIPCycle()
        self.interactor?.loadRepository.accept(.init(id: id))
    }
    
    func configureVIPCycle() {
        // configure VIP Cycle
        let viewController = self
        let interactor = RepositoryShowInteractor.init()
        let presenter = RepositoryShowPresenter.init()
        let router = RepositoryShowRouter()
        
        interactor.bind(to: presenter).disposed(by: disposeBag)
        presenter.bind(to: viewController).disposed(by: disposeBag)
        router.bind(to: viewController).disposed(by: disposeBag)
        
        router.dataStore = interactor
        viewController.interactor = interactor
        viewController.router = router
    
        // Binding VIP
        
        self.node.bind(state: self.displayRepositoryShowState.asObservable())
        self.node.bind(action: interactor)
        
        self.displayDissmiss
            .bind(to: router.dismiss)
            .disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
