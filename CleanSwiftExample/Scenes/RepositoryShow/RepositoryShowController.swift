import AsyncDisplayKit
import RxSwift
import RxCocoa

class RepositoryShowController: ASViewController<RepoShowContainerNode> {

    private let disposeBag = DisposeBag()
    
    init(repo: Repository) {
        super.init(node: .init(repo: repo))
        
        // TODO: configure VIP
        self.node.dismissButtonNode.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        self.node.pinButtonNode.rx.tap.map { _ in return true }
            .bind(to: self.node.pinButtonNode.rx.isSelected)
            .disposed(by: disposeBag)
        
        self.node.pinButtonNode.rx.tap.map { _ in return true }
            .bind(to: self.node.profileNode.rx.isPinned,
                  setNeedsLayout: self.node.profileNode)
            .disposed(by: disposeBag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
