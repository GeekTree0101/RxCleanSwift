import XCTest
import RxBlocking
import RxTest
import RxSwift
import RxCocoa

@testable import CleanSwiftExample

class RepositoryCommonWorkerTests: XCTestCase {
    
    var worker: RepositoryCommonWorkerTests.RepositoryCommonWorkerSpy!
    
    override func setUp() {
        self.worker = .init()
    }
    
    override func tearDown() {
        
    }
    
    func testLoadCachedRepository() {
        let repository = try! worker.loadCachedRepository(100).toBlocking().first()
        XCTAssertNotNil(repository)
        XCTAssertEqual(repository?.id ?? -1, 100)
    }
}

extension RepositoryCommonWorkerTests {
    
    class RepositoryCommonWorkerSpy: RepositoryCommonWorker {
        
        let repository: Repository = {
            return ReadJSONFile.shared.load("repository.json", type: Repository.self, from: RepositoryCommonWorkerSpy.self)!
        }()
        
        override func loadCachedRepository(_ id: Int) -> PrimitiveSequence<SingleTrait, Repository> {
            var repo = self.repository
            repo.id = id
            return Single.just(repo)
        }
    }
}

