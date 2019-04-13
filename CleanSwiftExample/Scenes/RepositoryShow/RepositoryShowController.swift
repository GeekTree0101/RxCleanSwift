import AsyncDisplayKit
import RxSwift
import RxCocoa
import ReactorKit

class RepositoryShowController: ASViewController<RepoShowContainerNode> {

    var disposeBag = DisposeBag()
    
    init(reactor: RepoReactor) {
        super.init(node: .init(reactor: reactor))
        
        self.node.dismissButtonNode.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
