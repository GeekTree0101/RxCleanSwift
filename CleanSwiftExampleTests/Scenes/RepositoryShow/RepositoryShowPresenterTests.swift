import XCTest
import RxBlocking
import RxTest
import RxSwift
import RxCocoa

@testable import CleanSwiftExample

class RepositoryShowPresenterTests: XCTestCase {
    
    var presenter: RepositoryShowPresenter!
    var controller: RepositoryShowPresenterTests.RepositoryShowControllerSpy!
    var disposeBag = DisposeBag()
    var scheduler: TestScheduler!
    
    let repository: Repository = {
        return ReadJSONFile.shared.load("repository.json", type: Repository.self, from: RepositoryShowPresenterTests.self)!
    }()
    
    override func setUp() {
        disposeBag = DisposeBag()
        controller = RepositoryShowPresenterTests.RepositoryShowControllerSpy.init()
        presenter = RepositoryShowPresenter.init()
        presenter.bind(to: controller).disposed(by: disposeBag)
        scheduler = TestScheduler.init(initialClock: 0)
    }

    override func tearDown() {
        
    }

    func testCreateRepositoryShowViewModel() {
        let input = scheduler.createHotObservable([.next(100, RepositoryShowModels.Show.Response.init(repo: repository))])
        let output = scheduler.createObserver(RepositoryShowModels.Show.ViewModel.self)
        
        input.bind(to: presenter.createRepositoryShowViewModel).disposed(by: disposeBag)
        controller.displayRepositoryShowState.subscribe(output).disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(output.events.count, 1)
        XCTAssertEqual(output.events.first?.value.element?.title, "mojombo")
    }

    func testDismissRepositoryShow() {
        let input = scheduler.createHotObservable([.next(100, RepositoryShowModels.Dismiss.Response.init())])
        let output = scheduler.createObserver(RepositoryShowModels.Dismiss.ViewModel.self)
        
        input.bind(to: presenter.dismissRepositoryShow).disposed(by: disposeBag)
        controller.displayDissmiss.subscribe(output).disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(output.events.count, 1)
        XCTAssertNotNil(output.events.first?.value.element)
    }
}

extension RepositoryShowPresenterTests {
    
    class RepositoryShowControllerSpy: RepositoryShowController {
        
        
    }
}

