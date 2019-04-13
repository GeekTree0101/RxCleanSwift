import AsyncDisplayKit
import RxSwift
import RxCocoa

protocol RepositoryListDisplayLogic: class {
    
    var displayErrorRelay: PublishRelay<Error?> { get }
    var displayItemsRelay: PublishRelay<RepositoryListModel.ViewModel> { get }
}

class RepositoryListController:
ASViewController<RepositoryListContainerNode> & RepositoryListDisplayLogic {
    
    lazy var presenter = RepositoryListPresenter.init(self)
    lazy var interactor = RepositoryListInteractor.init(presenter)
    
    private var router: RepositoryListRouterLogic?
    
    var displayErrorRelay: PublishRelay<Error?> = .init()
    var displayItemsRelay: PublishRelay<RepositoryListModel.ViewModel> = .init()
    
    private var batchContext: ASBatchContext?
    private var items: [RepoReactor] = []
    private var since: Int? {
        return self.items.count == 0 ? nil: self.items.count
    }
    
    let disposeBag = DisposeBag()
    
    init() {
        super.init(node: .init())
        self.node.tableNode.delegate = self
        self.node.tableNode.dataSource = self
        self.configureVIP()
        self.configureDisplay()
    }
    
    func configureVIP() {
        let viewController = self
        let router = RepositoryListRouter.init()
        router.viewController = viewController
        viewController.router = router
    }
    
    func configureDisplay() {
        
        self.displayItemsRelay
            .subscribe(onNext: { [weak self] viewModel in
                guard let self = self else { return }
                
                let startIndex = self.items.count
                self.items.append(contentsOf: viewModel.repoReactors)
                let indexPaths: [IndexPath] = (startIndex..<startIndex + viewModel.repoReactors.count)
                    .map({ index in
                        return IndexPath.init(row: index, section: 0)
                    })
                
                self.node.tableNode.performBatchUpdates({
                    self.node.tableNode.insertRows(at: indexPaths, with: .fade)
                }, completion: { fin in
                    self.batchContext?.completeBatchFetching(fin)
                })
            })
            .disposed(by: disposeBag)
        
        self.displayErrorRelay
            .subscribe(onNext: { [weak self] error in
                self?.batchContext?.completeBatchFetching(true)
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RepositoryListController: ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            guard self.items.count > indexPath.row else { return ASCellNode() }
            return RepositoryListCellNode(self.items[indexPath.row])
        }
    }
}

extension RepositoryListController: ASTableDelegate {
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        guard self.items.count > indexPath.row else { return }
        self.router?.presentToRepositoryShow(self.items[indexPath.row])
    }
    
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        return self.batchContext == nil || !(self.batchContext?.isFetching() ?? true)
    }
    
    func tableNode(_ tableNode: ASTableNode,
                   willBeginBatchFetchWith context: ASBatchContext) {
        
        self.interactor.loadMoreRelay.accept(RepositoryListModel.Request.init(since: self.since))
        self.batchContext = context
    }
}
