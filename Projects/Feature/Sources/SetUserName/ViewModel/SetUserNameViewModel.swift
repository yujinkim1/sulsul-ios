//
//  SelectUserNameViewModel.swift
//  Feature
//
//  Created by Yujin Kim on 2023-12-17.
//

import Foundation
import Combine
import Service

final class SelectUserNameViewModel: NSObject {
    
    private let jsonDecoder = JSONDecoder()
    
    private var userName: String = ""
    
    private func requestRandomUserName() {
        NetworkWrapper.shared.getBasicTask(stringURL: "/users/nickname") { result in
            switch result {
            case .success(let responseData):
                print(responseData)
            case .failure(let error):
                print(error)
            }
        }
    }
}
