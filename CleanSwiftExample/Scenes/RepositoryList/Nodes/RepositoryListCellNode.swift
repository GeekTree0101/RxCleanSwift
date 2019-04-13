import Foundation
import AsyncDisplayKit

class RepositoryListCellNode: ASCellNode {
    
    struct Const {
        static let cellInsets: UIEdgeInsets = .init(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
        static let contentSpacing: CGFloat = 10.0
    }
    
    lazy var profileNode: ProfileNode = .init(scale: .medium)
    lazy var infoNode: InformationNode = .init(align: .start)
    
    init(repo: Repository) {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.selectionStyle = .none
        
        self.profileNode.rx.url.onNext(repo.user?.profileURL)
        self.infoNode.rx.title.onNext(repo.user?.username)
        self.infoNode.rx.subTitle.onNext(repo.desc)
    }
    
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
