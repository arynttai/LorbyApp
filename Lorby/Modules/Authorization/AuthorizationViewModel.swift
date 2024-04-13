import Foundation

protocol AuthorizationViewDelegate: AnyObject {
    func showTopNotification(message: String)
    func authenticationDidComplete()
    func authenticationDidFail(withError error: String)
}

class AuthorizationViewModel {
    
    weak var delegate: AuthorizationViewDelegate?

    func loginButtonTapped(login: String?, password: String?) {
        guard let login = login, !login.isEmpty else {
            delegate?.showTopNotification(message: "Введите логин")
            return
        }
        
        guard let password = password, !password.isEmpty else {
            delegate?.showTopNotification(message: "Введите пароль")
            return
        }
        
        let userCredentials = UserLoginDTO(email: login, password: password)
        loginRequest(user: userCredentials)
    }

    func loginRequest(user: UserLoginDTO) {
        NetworkLayer.shared.login(loginCredentials: user) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let authResponse):
                    self?.delegate?.authenticationDidComplete()
                case .failure(let error):
                    self?.delegate?.authenticationDidFail(withError: "Ошибка при входе: \(error.localizedDescription)")
                }
            }
        }
    }
}
