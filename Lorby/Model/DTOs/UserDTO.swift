import Foundation

struct UserDTO {
    var login: String
    var email: String
    var password: String
    var passwordConfirm: String
}
extension UserDTO: Encodable {}

