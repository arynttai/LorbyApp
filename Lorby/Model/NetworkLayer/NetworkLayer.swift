import UIKit
import Alamofire

protocol NetworkLayerDelegate: AnyObject {
    func authenticationDidComplete(success: Bool)
}

class NetworkLayer {
    
    static let shared = NetworkLayer()
    weak var delegate: NetworkLayerDelegate?
    
    private init() { }
    
    func register(userCredentials: UserDTO, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        guard let url = NetworkAPI.register.url else {
            return
        }
        
        AF.request(url, method: .post, parameters: userCredentials, encoder: JSONParameterEncoder.default)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                        completion(.success(loginResponse))
                    } catch {
                        completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func login(loginCredentials: UserLoginDTO, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        guard let url = NetworkAPI.login.url else {
            return
        }
        
        AF.request(url, method: .post, parameters: loginCredentials, encoder: JSONParameterEncoder.default)
            .validate()
            .responseData { [weak self] response in
                switch response.result {
                case .success(let data):
                    do {
                        let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                        completion(.success(loginResponse))
                        DispatchQueue.main.async {
                            self?.delegate?.authenticationDidComplete(success: true)
                        }
                    } catch {
                        completion(.failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)))
                        DispatchQueue.main.async {
                            self?.delegate?.authenticationDidComplete(success: false)
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                    DispatchQueue.main.async {
                        self?.delegate?.authenticationDidComplete(success: false)
                    }
                }
            }
    }
}
