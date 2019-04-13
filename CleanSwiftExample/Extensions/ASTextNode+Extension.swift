import AsyncDisplayKit

extension ASTextNode {
    
    var isEmpty: Bool {
        return self.attributedText?.string.isEmpty ?? true
    }
}
