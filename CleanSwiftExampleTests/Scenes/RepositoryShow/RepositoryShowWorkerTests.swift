import XCTest
import RxBlocking
import RxTest
import RxSwift
import RxCocoa

@testable import CleanSwiftExample

class RepositoryShowWorkerTests: XCTestCase {
    
    var worker: RepositoryShowWorkerSpy!
    
    override func setUp() {
        worker = RepositoryShowWorkerSpy.init()
    }
    
    override func tearDown() {
        
    }
    
    func testTogglePin() {
        let repository = try! worker.togglePin(100).toBlocking().first()
        XCTAssertNotNil(repository)
        XCTAssertEqual(repository?.id ?? -1, 100)
        XCTAssertTrue(repository?.isPinned ?? false)
    }
}

class RepositoryShowWorkerSpy: RepositoryShowWorker {
    
    let repository: Repository = {
        return ReadJSONFile.shared.load("repository.json", type: Repository.self, from: RepositoryShowWorkerSpy.self)!
    }()
    
    override func togglePin(_ id: Int) -> PrimitiveSequence<SingleTrait, Repository> {
        var repo = self.repository
        repo.id = id
        repo.isPinned = true
        return Single.just(repo)
    }
}
