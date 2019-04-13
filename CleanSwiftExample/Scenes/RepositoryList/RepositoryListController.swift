import AsyncDisplayKit
import RxSwift
import RxCocoa

protocol RepositoryListDisplayLogic: class {
    
    func displayErrorStatus(_ error: Error?)
    func displayRepositoryListItems(_ viewModel: RepositoryListModel.ViewModel)
}

class RepositoryListController: ASViewController<RepositoryListContainerNode> {
    
    private var interactor: RepositoryListInteractorLogic?
    private var router: RepositoryListRouterLogic?
    
    private var batchContext: ASBatchContext?
    private var items: [Repository] = []
    private var since: Int? {
        return self.items.count == 0 ? nil: self.items.count
    }

    init() {
        super.init(node: .init())
        self.node.tableNode.delegate = self
        self.node.tableNode.dataSource = self
        self.configureVIP()
    }
    
    func configureVIP() {
        let viewController = self
        let interactor = RepositoryListInteractor.init()
        let presenter = RepositoryListPresenter.init()
        let router = RepositoryListRouter.init()
        
        viewController.router = router
        viewController.interactor = interactor
        
        router.viewController = viewController
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RepositoryListController: RepositoryListDisplayLogic {
    
    func displayRepositoryListItems(_ viewModel: RepositoryListModel.ViewModel) {
        let startIndex = self.items.count
        self.items.append(contentsOf: viewModel.repos)
        let indexPaths: [IndexPath] = (startIndex..<startIndex + viewModel.repos.count)
            .map({ index in
                return IndexPath.init(row: index, section: 0)
            })
        
        self.node.tableNode.performBatchUpdates({
            self.node.tableNode.insertRows(at: indexPaths, with: .fade)
        }, completion: { fin in
            self.batchContext?.completeBatchFetching(fin)
        })
    }
    
    func displayErrorStatus(_ error: Error?) {
        self.batchContext?.completeBatchFetching(true)
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
            return RepositoryListCellNode(repo: self.items[indexPath.row])
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
        
        self.interactor?.loadMore(RepositoryListModel.Request.init(since: self.since))
        self.batchContext = context
    }
}
