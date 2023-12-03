//
//  APIEndpoint.swift
//  Service
//
//  Created by 이범준 on 2023/11/20.
//

import Foundation
import Alamofire

enum APIEndpoint: Endpoint {

    case example(ExampleAPI)
    case user(userAPI)
    
    var baseURLString: String {
    #if DEBUG
        return "https://example/api/v1/"
    #else
        return ""
    #endif
    }
    
    var path: String {
        switch self {
        case .example(let api):
            print("user/\(api.path)")
            return "user/\(api.path)"
        case .user(let api):
            print("user/\(api.path)")
            return "user/\(api.path)"
        }
    }
    
    var headers: HTTPHeaders {
        let token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        var basicHeader: HTTPHeaders = ["Content-Type": "application/json"]
        switch self {
        case .user(let api):
            switch api {
            case .login, .register,
                 .checkEmail, .findEmail,
                 .findPassword, .checkPhone:
                break
            default:
                basicHeader.add(name: "Authorization", value: token)
            }
            return basicHeader
            
        case .example(_):
            return basicHeader
        }
    }
}
