import Foundation
import AsyncDisplayKit
import RxSwift

class RepositoryListCellNode: ASCellNode {
    
    typealias ViewModel = RepositoryListModels.RepositorySequence.ViewModel.CellViewModel
    struct Const {
        static let cellInsets: UIEdgeInsets =
            .init(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
        static let contentSpacing: CGFloat = 10.0
    }
    
    lazy var profileNode: ProfileNode = .init(scale: .medium)
    lazy var infoNode: InformationNode = .init(align: .start)
    
    var disposeBag = DisposeBag()
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.selectionStyle = .none
    }
    
    func bind(viewModel: ViewModel) {
        
        viewModel.state.map({ $0?.profileURL })
            .distinctUntilChanged()
            .bind(to: profileNode.rx.url)
            .disposed(by: disposeBag)
        
        viewModel.state.map({ $0?.title })
            .distinctUntilChanged()
            .bind(to: self.infoNode.rx.title,
                  setNeedsLayout: infoNode)
            .disposed(by: disposeBag)
        
        viewModel.state.map({ $0?.desc })
            .distinctUntilChanged()
            .bind(to: self.infoNode.rx.subTitle,
                  setNeedsLayout: infoNode)
            .disposed(by: disposeBag)
        
        viewModel.state.map({ $0?.isPinned ?? false })
            .distinctUntilChanged()
            .bind(to: self.profileNode.rx.isPinned,
                  setNeedsLayout: self.profileNode)
            .disposed(by: disposeBag)
    }
}

extension RepositoryListCellNode {
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        infoNode.style.flexShrink = 1.0
        infoNode.style.flexGrow = 1.0
        
        let contentStackLayout = ASStackLayoutSpec(direction: .horizontal,
                                                   spacing: Const.contentSpacing,
                                                   justifyContent: .start,
                                                   alignItems: .center,
                                                   children: [profileNode, infoNode])
        
        return ASInsetLayoutSpec(insets: Const.cellInsets,
                                 child: contentStackLayout)
    }
}
