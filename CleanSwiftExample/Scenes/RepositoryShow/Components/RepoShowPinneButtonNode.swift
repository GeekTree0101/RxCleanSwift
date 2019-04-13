import AsyncDisplayKit

class RepoShowPinneButtonNode: ASButtonNode {
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.backgroundColor = .orange
                self.borderColor = UIColor.white.cgColor
                self.borderWidth = 2.0
            } else {
                self.backgroundColor = .white
                self.borderColor = UIColor.orange.cgColor
                self.borderWidth = 2.0
            }
        }
    }
    
    override init() {
        super.init()
        self.style.height = .init(unit: .points, value: 60.0)
        self.cornerRadius = 10.0
        self.setTitle("Pin", with: UIFont.boldSystemFont(ofSize: 20.0), with: .orange, for: .normal)
        self.setTitle("Pinned", with: UIFont.boldSystemFont(ofSize: 20.0), with: .white, for: .selected)
        self.isSelected = false
    }
}
