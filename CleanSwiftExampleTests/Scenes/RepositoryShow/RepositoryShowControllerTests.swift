import XCTest
import RxBlocking
import RxTest
import RxSwift
import RxCocoa
import AsyncDisplayKit
import UIKit

@testable import CleanSwiftExample

class RepositoryShowControllerTests: XCTestCase {
    
    var controller: RepositoryShowController!
    var interactorLogic: RepositoryShowControllerTests.RepositoryShowInteractorLogicSpy!
    var disposeBag = DisposeBag()
    var scheduler: TestScheduler!
    
    override func setUp() {
        scheduler = TestScheduler.init(initialClock: 0)
        controller = RepositoryShowController.init()
        disposeBag = DisposeBag()
        interactorLogic = RepositoryShowControllerTests.RepositoryShowInteractorLogicSpy.init()
        controller.interactor = interactorLogic
        controller.node.disposeBag = DisposeBag()
        controller.node.bind(action: interactorLogic)
    }
    
    override func tearDown() {
        
    }
    
    func testLoadRepository() {
        let input = scheduler.createHotObservable([.next(100, ())])
        let output = scheduler.createObserver(RepositoryShowModels.Show.Request.self)
        
        interactorLogic.loadRepository.subscribe(output).disposed(by: disposeBag)
        input.subscribe(onNext: { [weak self] _ in
            self?.controller.viewDidLoad()
        }).disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(output.events.count, 1)
    }
    
    func testDidTapDismiss() {
        let output = BehaviorRelay<RepositoryShowModels.Dismiss.Request?>(value: nil)
        interactorLogic.didTapDismissButton.bind(to: output).disposed(by: disposeBag)
        controller.node.dismissButtonNode.sendActions(forControlEvents: .touchUpInside, with: UIEvent.init())
        
        XCTAssertNotNil(try! output.toBlocking().first()?.value)
    }
    
    func testDidTapPin() {
        let output = BehaviorRelay<RepositoryShowModels.Show.Request?>(value: nil)
        interactorLogic.didTapPin.bind(to: output).disposed(by: disposeBag)
        self.controller.node.pinButtonNode.sendActions(forControlEvents: .touchUpInside, with: nil)

        XCTAssertNotNil(try! output.toBlocking().first()?.value)
    }
}

extension RepositoryShowControllerTests {
    
    class RepositoryShowInteractorLogicSpy: RepositoryShowInteractorLogic {
        
        public var loadRepository: PublishRelay<RepositoryShowModels.Show.Request> = .init()
        public var didTapDismissButton: PublishRelay<RepositoryShowModels.Dismiss.Request> = .init()
        public var didTapPin: PublishRelay<RepositoryShowModels.Show.Request> = .init()
    }
}
