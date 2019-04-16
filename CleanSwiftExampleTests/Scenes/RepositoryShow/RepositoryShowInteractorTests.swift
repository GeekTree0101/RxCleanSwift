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
        var repo = RepositoryShowInteractorTests.createMockRepository()
        repo.id = 999
        interactor.repositoryStore = ReactiveDataStore<Repository>.init(repo)
        
        let scheduler = TestScheduler.init(initialClock: 0)
        let inputObserver = scheduler.createHotObservable(
            [.next(100, RepositoryShowModels.Show.Request.init()),
             .next(200, RepositoryShowModels.Show.Request.init()),
             .next(300, RepositoryShowModels.Show.Request.init())])
        let outputObserver: TestableObserver<Int> = scheduler.createObserver(Int.self)
        
        inputObserver
            .bind(to: interactor.didTapPin)
            .disposed(by: disposeBag)
        
        spyPresent.createRepositoryShowViewModel
            .map({ $0.repo.id })
            .subscribe(outputObserver)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(outputObserver.events, [.next(100, 999), .next(200, 999), .next(300, 999)])
    }

    func testDismiss() {
        let spyPresent = RepositoryShowPresenterSpy.init()
        interactor.bind(to: spyPresent).disposed(by: disposeBag)
        var repo = RepositoryShowInteractorTests.createMockRepository()
        repo.id = 999
        interactor.repositoryStore = ReactiveDataStore<Repository>.init(repo)
        
        let scheduler = TestScheduler.init(initialClock: 0)
        
        let inputObserver = scheduler.createHotObservable(
            [.next(100, RepositoryShowModels.Dismiss.Request.init()),
             .next(200, RepositoryShowModels.Dismiss.Request.init()),
             .next(300, RepositoryShowModels.Dismiss.Request.init())])
        
        let outputObserver: TestableObserver<RepositoryShowModels.Dismiss.Response> =
            scheduler.createObserver(RepositoryShowModels.Dismiss.Response.self)

        inputObserver
            .bind(to: interactor.didTapDismissButton)
            .disposed(by: disposeBag)
        
        spyPresent.dismissRepositoryShow
            .subscribe(outputObserver)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(outputObserver.events.count, 3)
        XCTAssertEqual(interactor.repositoryStore?.value.id ?? -1, 999)
    }
    
    func testTapPin() {
        let spyPresent = RepositoryShowPresenterSpy.init()
        interactor.bind(to: spyPresent).disposed(by: disposeBag)
        var repo = RepositoryShowInteractorTests.createMockRepository()
        repo.id = 999
        interactor.repositoryStore = ReactiveDataStore<Repository>.init(repo)
        
        let scheduler = TestScheduler.init(initialClock: 0)
        
        let inputObserver = scheduler.createHotObservable(
            [.next(100, RepositoryShowModels.Show.Request.init()),
             .next(200, RepositoryShowModels.Show.Request.init()),
             .next(300, RepositoryShowModels.Show.Request.init())])
        let outputObserver: TestableObserver<Int> = scheduler.createObserver(Int.self)
        
        inputObserver
            .bind(to: interactor.didTapPin)
            .disposed(by: disposeBag)
        
        spyPresent.createRepositoryShowViewModel
            .map({ $0.repo.id })
            .subscribe(outputObserver)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(outputObserver.events.count, 3)
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
