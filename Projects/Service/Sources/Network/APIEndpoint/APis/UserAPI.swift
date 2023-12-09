//
//  UserAPI.swift
//  Service
//
//  Created by 이범준 on 2023/11/20.
//

import Foundation

extension APIEndpoint {
    
    enum userAPI {
        case login
        case logout
        case register
        case account
        case checkEmail
        case findPassword
        case findEmail
        case certitylist
        case checkPhone
        case getMailInfo
        case updateMailInfo
        case updatePassword
        case autoLogin
        case closed
        
        var path: String {
            switch self {
            case .login:
                return "login"
            case .logout:
                return "logout"
            case .register:
                return "register"
            case .account:
                return "account"
            case .checkEmail:
                return "checkemail"
            case .findPassword:
                return "find_password"
            case .findEmail:
                return "findemail"
            case .certitylist:
                return "certifylist"
            case .checkPhone:
                return "checkphone"
            case .getMailInfo:
                return "get_mail_info"
            case .updateMailInfo:
                return "update_mail_info"
            case .updatePassword:
                return "update_password"
            case .autoLogin:
                return "auto_login"
            case .closed:
                return "closed"
            }
        }
    }
    
}
