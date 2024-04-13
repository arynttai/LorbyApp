import UIKit

class RegisterViewController: UIViewController {
    
    private var viewModel = RegisterViewModel()
    private var contentView = RegisterView()
    
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupButtonTargets()
        configurePasswordValidationHandler()
    }
    
    private func setupButtonTargets() {
        contentView.nextButton.addTarget(self, action: #selector(enterButtonTapped), for: .touchUpInside)
        contentView.passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
    }
    
    @objc func enterButtonTapped() {
        guard let username = contentView.loginTextField.text, !username.isEmpty,
              let email = contentView.mailAddressTextField.text, !email.isEmpty,
              let password = contentView.passwordTextField.text, !password.isEmpty,
              let repeatPassword = contentView.repeatPasswordTextField.text, !repeatPassword.isEmpty else {
            return
        }
        
        let user = UserDTO(login: username, email: email, password: password, passwordConfirm: repeatPassword)
        viewModel.registerUser(user) { success in
            if success {
                print("Пользователь успешно зарегистрирован")
            } else {
                print("Не получилось зарегистрировать")
            }
        }
    }

    @objc func passwordTextFieldDidChange() {
        viewModel.validatePassword(contentView.passwordTextField.text,
                                   repeatedPassword: contentView.repeatPasswordTextField.text)
    }
    
    private func configurePasswordValidationHandler() {
        viewModel.passwordValidationResult = { [weak self] isLengthValid, isAlphanumeric, containsDigit, containsSpecialCharacter, passwordsMatch in
            self?.contentView.updatePasswordValidationLabels(
                isLengthValid: isLengthValid,
                isAlphanumeric: isAlphanumeric,
                containsDigit: containsDigit,
                containsSpecialCharacter: containsSpecialCharacter,
                passwordsMatch: passwordsMatch)
        }
    }
}

extension RegisterViewController: RegistrationContentViewDelegate {
    func nextButtonTapped(user: UserDTO) {
        viewModel.registerUser(user) { result in
            print("Не получилось зарегать")
        }
    }
    
    func checkPassword(password: String) {
    }
    
}
