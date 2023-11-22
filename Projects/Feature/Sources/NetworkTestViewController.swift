//
//  NetworkTestViewController.swift
//  Feature
//
//  Created by 이범준 on 2023/11/21.
//

import UIKit
import Service

public final class NetworkTestViewController: UIViewController {
    
//    
//    NetworkWrapper.shared.postAuthTask(stringURL: stringURL, parameters: parameters) { result in
//        switch result {
//        case .success(let responseData):
//            if let data = try? JSONDecoder().decode(CoinnessAuthToken.self, from: responseData) {
//                
//                KeychainKeys.setTokens(accessToken: data.accessToken, refreshToken: data.refreshToken)
//                LogDebug("---------RefreshToken: \(data)")
//                promise(.success(()))
//            }
//            promise(.failure(HTTPError.typeMismatchError))
//            
//        case .failure(let error):
//            promise(.failure(error))
//            if let errorCode = error.getErrorCode(), errorCode == 401 || (errorCode == 403 && error.getError() == "PERMANENT_BLOCK") {
//                KeychainKeys.removeTokens()
//            }
//            LogError(error)
//        }
//    }
    
    
}
