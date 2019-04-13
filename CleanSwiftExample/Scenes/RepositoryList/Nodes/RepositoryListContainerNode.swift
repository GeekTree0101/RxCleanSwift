import AsyncDisplayKit

final class RepositoryListContainerNode: ASDisplayNode {
    
    public let tableNode: ASTableNode = .init()
    
    override init() {
        super.init()
        self.backgroundColor = .white
        self.automaticallyManagesSubnodes = true
        self.automaticallyRelayoutOnSafeAreaChanges = true
    }
    
    override func didLoad() {
        super.didLoad()
        self.tableNode.view.separatorStyle = .none
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        var insets = self.safeAreaInsets
        insets.bottom = 0.0
        return ASInsetLayoutSpec(insets: insets, child: tableNode)
    }
}
