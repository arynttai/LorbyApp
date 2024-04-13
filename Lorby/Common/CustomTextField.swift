import UIKit

class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
    }
    
    private func setUpUI() {
        layer.cornerRadius = 12
        autocorrectionType = .no
        autocapitalizationType = .none
        clearButtonMode = .whileEditing
        backgroundColor = UIColor(red: 247/255.0, green: 247/255.0, blue: 248/255.0, alpha: 1)
        textColor = .black
        
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: self.bounds.height))
        self.leftView = leftView
        leftViewMode = .always
        returnKeyType = .search
    }
}
