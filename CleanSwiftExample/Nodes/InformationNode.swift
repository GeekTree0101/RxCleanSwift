import AsyncDisplayKit
import RxSwift
import RxCocoa
import RxCocoa_Texture
import BonMot

extension Reactive where Base: InformationNode {
    
    typealias Const = InformationNode.Const
    
    var title: ASBinder<String?> {
        return base.titleNode.rx.text(Const.titleAttr.attributes)
    }
    
    var subTitle: ASBinder<String?> {
        return base.subTitleNode.rx.text(Const.subTitleAttr.attributes)
    }
}

final class InformationNode: ASDisplayNode {
    
    struct Const {
        static let titleAttr: StringStyle =
            StringStyle.init([.font(UIFont.boldSystemFont(ofSize: 18.0)),
                              .color(UIColor.black)])
        
        static let subTitleAttr: StringStyle =
            StringStyle.init([.font(UIFont.systemFont(ofSize: 14.0)),
                              .color(UIColor.gray)])
        
        static let moreSeeAttr: StringStyle =
            StringStyle.init([.font(UIFont.boldSystemFont(ofSize: 14.0)),
                              .color(UIColor.darkGray)])
        
        static let contentSpacing: CGFloat = 5.0
        static let subTitleMaxiumNumberOfLines: UInt = 2
    }
    
    lazy var titleNode: ASTextNode = {
        let node = ASTextNode()
        node.maximumNumberOfLines = 1
        
        switch align {
        case .start:
            node.truncationMode = .byTruncatingTail
        case .center:
            node.truncationMode = .byTruncatingMiddle
        }
        return node
    }()
    
    lazy var subTitleNode: ASTextNode = {
        let node = ASTextNode()
        
        switch align {
        case .start:
            node.maximumNumberOfLines = Const.subTitleMaxiumNumberOfLines
            node.truncationAttributedText =
                "... More See".styled(with: Const.moreSeeAttr)
            node.delegate = self
            node.isUserInteractionEnabled = true
        case .center:
            node.maximumNumberOfLines = 0
            node.truncationMode = .byTruncatingMiddle
        }
        return node
    }()
    
    enum InfoAlign {
        case start
        case center
    }
    
    let align: InfoAlign
    
    init(align: InfoAlign) {
        self.align = align
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let elements: [ASTextNode] = [titleNode, subTitleNode]
            .filter({ !$0.isEmpty })
            .map({ node -> ASTextNode in
                node.style.flexShrink = 1.0
                return node
            })
        
        return ASStackLayoutSpec(direction: .vertical,
                                 spacing: Const.contentSpacing,
                                 justifyContent: align == .start ? .start: .center,
                                 alignItems: align == .start ? .start: .center,
                                 children: elements)
    }
}

extension InformationNode: ASTextNodeDelegate {
    
    func textNodeTappedTruncationToken(_ textNode: ASTextNode!) {
        self.subTitleNode.maximumNumberOfLines = 0
        self.setNeedsLayout()
    }
}
