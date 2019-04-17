import XCTest
import RxBlocking
import RxTest
import RxSwift
import RxCocoa

@testable import CleanSwiftExample

class RepositoryShowPresenterTests: XCTestCase {
    
    var presenter: RepositoryShowPresenter!
    var disposeBag = DisposeBag()
    var scheduler: TestScheduler!
    
    let repository: Repository = {
        return ReadJSONFile.shared.load("repository.json", type: Repository.self, from: RepositoryShowPresenterTests.self)!
    }()
    
    override func setUp() {
        presenter = RepositoryShowPresenter.init()
        disposeBag = DisposeBag()
        scheduler = TestScheduler.init(initialClock: 0)
    }

    override func tearDown() {
        
    }

    func testCreateRepositoryShowViewModel() {
        let spyController = RepositoryShowControllerSpyForPresenterTest.init()
        presenter.bind(to: spyController).disposed(by: disposeBag)
        
        let input = scheduler.createHotObservable([.next(100, RepositoryShowModels.Show.Response.init(repo: repository))])
        let output = scheduler.createObserver(RepositoryShowModels.Show.ViewModel.self)
        
        input.bind(to: presenter.createRepositoryShowViewModel).disposed(by: disposeBag)
        spyController.displayRepositoryShowState.subscribe(output).disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(output.events.count, 1)
        XCTAssertEqual(output.events.first?.value.element?.title, "mojombo")
    }

    func testDismissRepositoryShow() {
        let spyController = RepositoryShowControllerSpyForPresenterTest.init()
        presenter.bind(to: spyController).disposed(by: disposeBag)
        
        let input = scheduler.createHotObservable([.next(100, RepositoryShowModels.Dismiss.Response.init())])
        let output = scheduler.createObserver(RepositoryShowModels.Dismiss.ViewModel.self)
        
        input.bind(to: presenter.dismissRepositoryShow).disposed(by: disposeBag)
        spyController.displayDissmiss.subscribe(output).disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(output.events.count, 1)
        XCTAssertNotNil(output.events.first?.value.element)
    }
}

class RepositoryShowControllerSpyForPresenterTest: RepositoryShowController {
    
    
    
}
