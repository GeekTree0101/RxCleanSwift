import XCTest
import RxBlocking
import RxTest
import RxSwift
import RxCocoa

@testable import CleanSwiftExample

class RepositoryShowInteractorTests: XCTestCase {
    
    var interactor: RepositoryShowInteractor!
    var disposeBag = DisposeBag()

    override func setUp() {
        self.interactor = RepositoryShowInteractor.init()
        self.interactor.worker = RepositoryShowWorkerSpy.init()
        self.disposeBag = DisposeBag()
    }

    override func tearDown() {
        
    }
    
    static func createMockRepository() -> Repository {
        return ReadJSONFile.shared.load("repository.json", type: Repository.self, from: RepositoryShowInteractorTests.self)!
    }

    func testLoadRepository() {
        let spyPresent = RepositoryShowPresenterSpy.init()
        interactor.bind(to: spyPresent).disposed(by: disposeBag)

        let scheduler = TestScheduler.init(initialClock: 0)
        let inputObserver = scheduler.createHotObservable([.next(100, 34), .next(200, 11), .next(300, 30)])
        let outputObserver: TestableObserver<Int> = scheduler.createObserver(Int.self)
        
        inputObserver
            .map { RepositoryShowModels.Show.Request.init(id: $0) }
            .bind(to: interactor.didTapPin)
            .disposed(by: disposeBag)
        
        spyPresent.createRepositoryShowViewModel
            .map({ $0.repo.id })
            .subscribe(outputObserver)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(outputObserver.events, [.next(100, 34), .next(200, 11), .next(300, 30)])
    }

    func testDismiss() {
        let spyPresent = RepositoryShowPresenterSpy.init()
        interactor.bind(to: spyPresent).disposed(by: disposeBag)
        
        let scheduler = TestScheduler.init(initialClock: 0)
        
        let inputObserver = scheduler.createHotObservable([.next(100, 34), .next(200, 11), .next(300, 30)])
        let outputObserver: TestableObserver<RepositoryShowModels.Dismiss.Response> =
            scheduler.createObserver(RepositoryShowModels.Dismiss.Response.self)

        inputObserver
            .map { RepositoryShowModels.Dismiss.Request.init(id: $0) }
            .bind(to: interactor.didTapDismissButton)
            .disposed(by: disposeBag)
        
        spyPresent.dismissRepositoryShow
            .subscribe(outputObserver)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(outputObserver.events.count, 3)
        XCTAssertEqual(interactor.repository?.id ?? -1, 30)
    }
    
    func testTapPin() {
        let spyPresent = RepositoryShowPresenterSpy.init()
        interactor.bind(to: spyPresent).disposed(by: disposeBag)
        
        let scheduler = TestScheduler.init(initialClock: 0)
        
        let inputObserver = scheduler.createHotObservable([.next(100, 34), .next(200, 11), .next(300, 30)])
        let outputObserver: TestableObserver<Int> = scheduler.createObserver(Int.self)
        
        inputObserver
            .map { RepositoryShowModels.Show.Request.init(id: $0) }
            .bind(to: interactor.didTapPin)
            .disposed(by: disposeBag)
        
        spyPresent.createRepositoryShowViewModel
            .map({ $0.repo.id })
            .subscribe(outputObserver)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(outputObserver.events, [.next(100, 34), .next(200, 11), .next(300, 30)])
    }
}

class RepositoryShowPresenterSpy: RepositoryShowPresenter {
    
    
}

class RepositoryShowWorkerSpy: RepositoryShowWorker {
    
    override func loadCachedRepository(_ id: Int) -> PrimitiveSequence<SingleTrait, Repository> {
        var repo = RepositoryShowInteractorTests.createMockRepository()
        repo.id = id
        return Single.just(repo)
    }
    
    override func togglePin(_ id: Int) -> PrimitiveSequence<SingleTrait, Repository> {
        var repo = RepositoryShowInteractorTests.createMockRepository()
        repo.id = id
        repo.isPinned = true
        return Single.just(repo)
    }
}
