import UIKit

protocol RegistrationContentViewDelegate: AnyObject {
    func checkPassword(password: String)
    func nextButtonTapped(user: UserDTO)
}

class RegisterView: UIView {
    
    weak var delegate: RegistrationContentViewDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Создать аккаунт \n Lorby"
        label.font = UIFont(name: "Avenir Next Medium", size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private(set) var mailAddressTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Введи адрес почты",
            attributes: [
                NSAttributedString.Key.font: UIFont(name: "Avenir Next Medium", size: 16),
                NSAttributedString.Key.foregroundColor: UIColor.gray
            ]
        )
        return textField
    }()
    
    private(set) var loginTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Avenir Next Medium", size: 16)
        textField.attributedPlaceholder = NSAttributedString(
            string: "Придумай логин",
            attributes: [
                NSAttributedString.Key.font: UIFont(name: "Avenir Next Medium", size: 16)!,
                NSAttributedString.Key.foregroundColor: UIColor.gray
            ]
        )
        
        return textField
    }()
    
    private(set) var passwordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Avenir Next Medium", size: 16)
        textField.isSecureTextEntry = true
        textField.attributedPlaceholder = NSAttributedString(
            string: "Создай пароль",
            attributes: [
                NSAttributedString.Key.font: UIFont(name: "Avenir Next Medium", size: 16)!,
                NSAttributedString.Key.foregroundColor: UIColor.gray
            ]
        )
        
        let button = UIButton(type: .custom)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.setImage(UIImage(named: "eyeIcon"), for: .normal)
        button.setImage(UIImage(named: "eyeSelectedIcon"), for: .selected)
        button.frame = CGRect(x: CGFloat(textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(togglePasswordVisible), for: .touchUpInside)
        textField.rightView = button
        textField.rightViewMode = .always
        return textField
    }()
    
    private lazy var passwordLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "· От 8 до 15 символов"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next Medium", size: 12)
        label.textColor = .gray
        return label
    }()
    
    private lazy var alphanumericLabel: UILabel = {
        let label = UILabel()
        label.text = "· Строчные и прописные буквы"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next Medium", size: 12)
        label.textColor = .gray
        return label
    }()
    
    private lazy var numericDigitLabel: UILabel = {
        let label = UILabel()
        label.text = "· Минимум 1 цифра"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next Medium", size: 12)
        label.textColor = .gray
        return label
    }()
    
    private lazy var specialCharacterLabel: UILabel = {
        let label = UILabel()
        label.text = "· Минимум 1 спецсимвол (!, #, $...)"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next Medium", size: 12)
        label.textColor = .gray
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        return stack
    }()
    
    private(set) var repeatPasswordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Avenir Next Medium", size: 16)
        textField.isSecureTextEntry = true
        textField.attributedPlaceholder = NSAttributedString(
            string: "Повтори пароль",
            attributes: [
                NSAttributedString.Key.font: UIFont(name: "Avenir Next Medium", size: 16),
                NSAttributedString.Key.foregroundColor: UIColor.gray
            ]
        )
        let button = UIButton(type: .custom)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.setImage(UIImage(named: "eyeIcon"), for: .normal)
        button.setImage(UIImage(named: "eyeSelectedIcon"), for: .selected)
        button.frame = CGRect(x: CGFloat(textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(toggleRepeatPasswordVisible), for: .touchUpInside)
        textField.rightView = button
        
        textField.rightViewMode = .always
        return textField
    }()
    
    private var passworDontMatch: UILabel = {
        let label = UILabel()
        label.text = "Пароли не совпадают"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next Medium", size: 12)
        label.textColor = .red
        label.isHidden = true
        return label
    }()
    
    private(set) var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Далее", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatePasswordValidationLabels(isLengthValid: Bool, isAlphanumeric: Bool, containsDigit: Bool, containsSpecialCharacter: Bool, passwordsMatch: Bool) {
        passwordLengthLabel.textColor = isLengthValid ? .green : .red
        alphanumericLabel.textColor = isAlphanumeric ? .green : .red
        numericDigitLabel.textColor = containsDigit ? .green : .red
        specialCharacterLabel.textColor = containsSpecialCharacter ? .green : .red
        
        passwordLengthLabel.text = "· От 8 до 15 символов \(isLengthValid ? "✅" : "❌")"
        alphanumericLabel.text = "· Строчные и прописные буквы \(isAlphanumeric ? "✅" : "❌")"
        numericDigitLabel.text = "· Минимум 1 цифра \(containsDigit ? "✅" : "❌")"
        specialCharacterLabel.text = "· Минимум 1 спецсимвол (!, #, $...) \(containsSpecialCharacter ? "✅" : "❌")"
        passworDontMatch.isHidden = passwordsMatch
    }
}

extension RegisterView: UITextFieldDelegate {
    @objc func togglePasswordVisible(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    @objc func toggleRepeatPasswordVisible(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        repeatPasswordTextField.isSecureTextEntry = !repeatPasswordTextField.isSecureTextEntry
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}

extension RegisterView {
    private func setUp() {
        setUpSubviews()
        setUpConstraints()
    }
    
    private func setUpSubviews() {
        addSubview(titleLabel)
        addSubview(mailAddressTextField)
        addSubview(loginTextField)
        addSubview(passwordTextField)

        addSubview(stackView)
        stackView.addArrangedSubview(passwordLengthLabel)
        stackView.addArrangedSubview(alphanumericLabel)
        stackView.addArrangedSubview(numericDigitLabel)
        stackView.addArrangedSubview(specialCharacterLabel)
        addSubview(repeatPasswordTextField)
        addSubview(nextButton)
        addSubview(passworDontMatch)
    }
    
    private func setUpConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(140)
            make.leading.equalTo(self).offset(51)
            make.trailing.equalTo(self).offset(-51)
            make.height.equalTo(70)
        }
        
        mailAddressTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.equalTo(self).offset(16)
            make.trailing.equalTo(self).offset(-16)
            make.height.equalTo(52)
        }
        
        loginTextField.snp.makeConstraints { make in
            make.top.equalTo(mailAddressTextField.snp.bottom).offset(14)
            make.leading.equalTo(self).offset(16)
            make.trailing.equalTo(self).offset(-16)
            make.height.equalTo(52)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(loginTextField.snp.bottom).offset(14)
            make.leading.equalTo(self).offset(16)
            make.trailing.equalTo(self).offset(-16)
            make.height.equalTo(52)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(8)
            make.leading.equalTo(self).offset(16)
            make.trailing.equalTo(self).offset(-16)
            make.height.equalTo(80)
        }
        
        repeatPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(14)
            make.leading.equalTo(self).offset(16)
            make.trailing.equalTo(self).offset(-16)
            make.height.equalTo(52)
        }
        
        passworDontMatch.snp.makeConstraints { make in
            make.top.equalTo(repeatPasswordTextField.snp.bottom).offset(8)
            make.leading.equalTo(self).offset(16)
            make.trailing.equalTo(self).offset(-16)
            make.height.equalTo(18)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(repeatPasswordTextField.snp.bottom).offset(45)
            make.leading.equalTo(self).offset(16)
            make.trailing.equalTo(self).offset(-16)
            make.height.equalTo(52)
        }
    }
}

