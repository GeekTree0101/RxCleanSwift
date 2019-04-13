import RxSwift

protocol RepositoryListRouterLogic: class {
    
    func presentToRepositoryShow(_ reactor: RepoReactor)
}

class RepositoryListRouter: RepositoryListRouterLogic {
    
    weak var viewController: RepositoryListController?
    
    func presentToRepositoryShow(_ reactor: RepoReactor) {
        
        viewController?.present(RepositoryShowController(reactor: reactor),
                                animated: true,
                                completion: nil)
    }
}
