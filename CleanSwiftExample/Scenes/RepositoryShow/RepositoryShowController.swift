import AsyncDisplayKit
import RxSwift
import RxCocoa
import ReactorKit

protocol RepositoryShowDisplayLogic: class {
    
    var displayShowReactor: PublishRelay<RepositoryShowModel.ViewModel> { get }
}

class RepositoryShowController: ASViewController<RepoShowContainerNode> & RepositoryShowDisplayLogic {
    
    var interactor: RepositoryShowInteractorLogic?
    var router: RepositoryShowRouterLogic?
    
    var displayShowReactor: PublishRelay<RepositoryShowModel.ViewModel> = .init()
    
    var disposeBag = DisposeBag()
    
    init(_ id: Int) {
        super.init(node: .init())
        self.configureVIPCycle()
        self.configureDisplay()
        self.configureRouter()
        
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
    
    func configureDisplay() {
        
        self.displayShowReactor
            .map({ $0.repoReactor })
            .bind(to: self.node.rx.bindReactor,
                  setNeedsLayout: self.node)
            .disposed(by: disposeBag)
    }
    
    func configureRouter() {
        guard let router = self.router else { return }
        
        self.node.dismissButtonNode.rx.tap
            .bind(to: router.dismiss)
            .disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
