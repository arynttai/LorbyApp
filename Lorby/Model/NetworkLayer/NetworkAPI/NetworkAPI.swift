import UIKit
import Alamofire

enum NetworkAPI {
    
    case login
    case register
    
    private var scheme: String {
        return "https"
    }
    
    private var host: String {
        return ""
    }

    private var path: String {
        switch self {
        case .login:
            return "/api/v1/auth/login"
        case .register:
            return "/api/v1/auth/register"
        }
    }
    
    internal var method: HTTPMethod {
        switch self {
        case .login, .register:
            return .post
        }
    }
    
    internal var parameters: Parameters? {
        switch self {
        case .login, .register:
            return nil
        }
    }
    
    var url: URL? {
        guard let components = components.url else {
            return nil
        }
        return components
    }

    private var components: URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        return components
    }
}

