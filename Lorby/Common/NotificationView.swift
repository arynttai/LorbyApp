import UIKit
import SnapKit

class NotificationView: UIView {
    
    lazy var notificationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next Regular", size: 16)
        label.text = "Неверный логин или пароль"
        label.textColor = .red
        label.textAlignment = .left
        label.backgroundColor = .white
        label.layer.cornerRadius = 12
        label.layer.borderColor = UIColor.red.cgColor
        label.layer.borderWidth = 1
        label.clipsToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        addSubview(notificationLabel)
        
        notificationLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
