import UIKit

class AuthorizationViewController: UIViewController {
    
    private var viewModel: AuthorizationViewModel
    let contentView = AuthorizationView()
    
    init(viewModel: AuthorizationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
        contentView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    private func setupBindings() {
        view.backgroundColor = .white
        contentView.enterButton.addTarget(self, action: #selector(enterButtonTapped), for: .touchUpInside)
        contentView.createNewAccountButton.addTarget(self, action: #selector(newAccountButtonTapped), for: .touchUpInside)
    }
    
    @objc private func enterButtonTapped() {
        viewModel.loginButtonTapped(login: contentView.userNameTF.text, password: contentView.passwordTF.text)
    }
    
    @objc private func newAccountButtonTapped() {
        let registerViewModel = RegisterViewModel()
        let registerViewController = RegisterViewController(viewModel: registerViewModel)
        navigationController?.pushViewController(registerViewController, animated: true)
    }
}

// MARK: - AuthorizationViewDelegate

extension AuthorizationViewController: AuthorizationViewDelegate {
    func showTopNotification(message: String) {
        let notificationView = UIView()
        notificationView.backgroundColor = .red
        notificationView.alpha = 0
        notificationView.frame = CGRect(x: 0, y: -50, width: view.bounds.width, height: 50)
        
        let label = UILabel(frame: notificationView.bounds)
        label.text = message
        label.textColor = .white
        label.textAlignment = .center
        notificationView.addSubview(label)
        
        view.addSubview(notificationView)
        
        UIView.animate(withDuration: 0.3, animations: {
            notificationView.alpha = 1
            notificationView.transform = CGAffineTransform(translationX: 0, y: 50)
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIView.animate(withDuration: 0.3, animations: {
                    notificationView.alpha = 0
                    notificationView.transform = CGAffineTransform(translationX: 0, y: -50)
                }) { _ in
                    notificationView.removeFromSuperview()
                }
            }
        }
    }
    
    func authenticationDidComplete() {
        let viewModel = MainViewModel()
        let mainViewController = MainViewController(viewModel: viewModel)
        navigationController?.setViewControllers([mainViewController], animated: true)
    }

    
    func authenticationDidFail(withError error: String) {
        showTopNotification(message: error)
    }
}
