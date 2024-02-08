//
//  Error+Extension.swift
//  DesignSystem
//
//  Created by 이범준 on 11/19/23.
//

import Foundation

extension Error {
    func getError() -> String? {
        if let networkError = self as? NetworkError, let error = networkError.error {
            return error
        }
        return nil
    }
    
    func getErrorMessage() -> String? {
        if let networkError = self as? NetworkError, let errorMessage = networkError.message {
            return errorMessage
        }
        return nil
    }
    
    func getErrorCode() -> Int? {
        if let networkError = self as? NetworkError, let statusCode = networkError.statusCode {
            return statusCode
        }
        return nil
    }
}

struct NetworkError: Error, Decodable {
    var statusCode: Int? = 0
    var error: String? = ""
    var message: String? = ""
    var forbiddenWords: [String]?
    
    struct Message: Decodable {
        let error: String?
        let message: String?
    }
}
