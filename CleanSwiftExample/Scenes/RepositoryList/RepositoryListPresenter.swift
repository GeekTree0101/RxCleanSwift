import RxSwift

protocol RepositoryListPresenterLogic: class {
    
    func load(_ response: RepositoryListModel.Response)
    func error(_ error: Error?)
}

class RepositoryListPresenter: RepositoryListPresenterLogic {
    
    weak var viewController: RepositoryListDisplayLogic?
    
    func load(_ response: RepositoryListModel.Response) {
        let viewModel = RepositoryListModel.ViewModel.init(repos: response.repos)
        viewController?.displayRepositoryListItems(viewModel)
    }
    
    func error(_ error: Error?) {
        viewController?.displayErrorStatus(error)
    }
}
