import RxSwift

protocol RepositoryListRouterLogic: class {
    
    func presentToRepositoryShow(_ repo: Repository)
}

class RepositoryListRouter: RepositoryListRouterLogic {
    
    weak var viewController: RepositoryListController?
    
    func presentToRepositoryShow(_ repo: Repository) {
        
        viewController?.present(RepositoryShowController.init(repo: repo),
                                animated: true,
                                completion: nil)
    }
}
