import AsyncDisplayKit
import RxSwift
import RxCocoa
import RxCocoa_Texture

extension Reactive where Base: ProfileNode {
    
    var isPinned: ASBinder<Bool> {
        return ASBinder(base) { node, isPinned in
            node.isPinned = isPinned
        }
    }
    
    var url: ASBinder<URL?> {
        return base.imageNode.rx.url
    }
}

final class ProfileNode: ASDisplayNode {
    
    struct Const {
        
        static let profileImageBorderColor: CGColor = UIColor.lightGray.cgColor
    }
    
    enum Scale: CGFloat {
        
        case small = 20.0
        case medium = 50.0
        case large = 100.0
        
        var badgeOffset: CGPoint {
            switch self {
            case .small, .medium:
                let scale = self.rawValue / 8.0
                return .init(x: -scale, y: -scale)
            case .large:
                return .init(x: -10.0, y: -10.0)
            }
        }
    }
    
    lazy var imageNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.style.preferredSize =
            .init(width: scale.rawValue, height: scale.rawValue)
        node.cornerRadius = scale.rawValue / 2.0
        node.clipsToBounds = true
        node.borderWidth = 0.5
        node.backgroundColor = .lightGray
        node.borderColor = Const.profileImageBorderColor
        return node
    }()
    
    lazy var badgeNode: ASButtonNode = {
        let node = ASButtonNode()
        node.backgroundColor = UIColor.white
        
        switch self.scale {
        case .small, .medium:
            let width = self.scale.rawValue / 4.0
            node.style.preferredSize = .init(width: width, height: width)
            node.cornerRadius = width / 2.0
            node.backgroundColor = UIColor.orange
        case .large:
            node.cornerRadius = 5.0
            node.borderColor = UIColor.orange.cgColor
            node.borderWidth = 1.0
            node.contentEdgeInsets = .init(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
            node.setTitle("Pinned",
                          with: UIFont.boldSystemFont(ofSize: 12.0),
                          with: UIColor.orange,
                          for: .normal)
        }
        
        return node
    }()
    
    public var isPinned: Bool = false
    
    private let scale: Scale
    
    init(scale: Scale) {
        self.scale = scale
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        if isPinned {
            let cornerLayout = ASCornerLayoutSpec(child: imageNode,
                                                  corner: badgeNode,
                                                  location: .bottomRight)
            cornerLayout.offset = self.scale.badgeOffset
            return cornerLayout
        } else {
            return ASWrapperLayoutSpec(layoutElement: imageNode)
        }
    }
}
