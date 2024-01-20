//
//  ProfileViewModel.swift
//  Feature
//
//  Created by 이범준 on 2024/01/16.
//

import Foundation
import Combine
import Service
import Alamofire // TODO: - Alamofire는 Service에서만 사용되도록 로직 수정 필요

struct ProfileMainViewModel {
    
    private let jsonDecoder = JSONDecoder()
    private var cancelBag = Set<AnyCancellable>()
    
    init() {
        getFeedsByMe()
    }
    
    // MARK: - 마이페이지: 내가 쓴 페이지 조회
    func getFeedsByMe() {
        let accessToken = KeychainStore.shared.read(label: "accessToken")
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken!
        ]
        NetworkWrapper.shared.getBasicTask(stringURL: "feeds/by-me", header: headers) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
}


//
//public func requestRandomNickname() {
//    let accessToken = KeychainStore.shared.read(label: "accessToken")
//    var headers: HTTPHeaders = [
//        "Content-Type": "application/json",
//        "Authorization": "Bearer " + accessToken!
//    ]
//    
//    NetworkWrapper.shared.getBasicTask(stringURL: "/users/nickname", header: headers) { [weak self] result in
//        guard let self = self else { return }
//        switch result {
//        case .success(let responseData):
//            if let userName = self.parseRandomNickname(from: responseData) {
//                self.userNameSubject.send(userName)
//            }
//        case .failure(let error):
//            print(error)
//        }
//    }
//}
