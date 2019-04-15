import AsyncDisplayKit
import RxSwift
import RxCocoa
import ReactorKit

protocol RepositoryShowDisplayLogic: class {
    
    var displayShowReactor: PublishRelay<RepositoryShowModels.RepositoryShowComponent.ViewModel> { get }
    var displayDissmiss: PublishRelay<RepositoryShowModels.RepositoryShowDismiss.ViewModel> { get }
}

class RepositoryShowController: ASViewController<RepoShowContainerNode> & RepositoryShowDisplayLogic {
    
    var interactor: RepositoryShowInteractorLogic?
    var router: RepositoryShowRouterLogic?
    
    var displayShowReactor: PublishRelay<RepositoryShowModels.RepositoryShowComponent.ViewModel> = .init()
    var displayDissmiss: PublishRelay<RepositoryShowModels.RepositoryShowDismiss.ViewModel> = .init()
    
    var disposeBag = DisposeBag()
    
    init(_ id: Int) {
        super.init(node: .init())
        self.configureVIPCycle()
        self.configureDisplay()
        
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
        
        self.displayDissmiss
            .subscribe(onNext: { [weak self] _ in
                self?.router?.dismiss.accept(())
            })
            .disposed(by: disposeBag)
        
        self.node.dismissButtonNode.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.interactor?.didTapDismissButton.accept(.init())
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
