import Foundation

class MainViewModel {
    var welcomeMessage: String = "" {
        didSet {
            onUpdate?()
        }
    }
    var subtitle: String = "Lorby - твой личный репетитор"
    var isUserLoggedIn: Bool = false {
        didSet {
            onUpdate?()
        }
    }
    
    var onUpdate: (() -> Void)?
    
    init() {
        loadInitialData()
    }
    
    func loadInitialData() {
        welcomeMessage = "С возвращением!"
        checkUserLoginStatus()
    }
    
    func checkUserLoginStatus() {
        isUserLoggedIn = true
    }
    
    func logOut() {
        isUserLoggedIn = false
        welcomeMessage = "До скорой встречи!"
    }
}
