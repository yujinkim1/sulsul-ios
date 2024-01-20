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
    private var loginStatus: Bool = false
    
    private var myFeeds = CurrentValueSubject<[MyFeed], Never>([])
    init() {
        getFeedsByMe()
    }
    
    // MARK: - 마이페이지: 내가 쓴 페이지 조회
    func getFeedsByMe() {
        //MARK: - 테스트용 토큰
        let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiIiLCJpYXQiOjE3MDU3NDk4MDEsImV4cCI6MTcwNjM1NDYwMSwiaWQiOjEsInNvY2lhbF90eXBlIjoiZ29vZ2xlIiwic3RhdHVzIjoiYWN0aXZlIn0.gucj-5g1CktXtAKqYp99K-_eI7sH_VmoyDTaVhKE6DU"
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken
        ]
        NetworkWrapper.shared.getBasicTask(stringURL: "/feeds/by-me", header: headers) { result in
            switch result {
            case .success(let response):
                if let myFeedsData = try? self.jsonDecoder.decode(RemoteFeedsByMeItem.self, from: response) {
                    myFeeds.send(myFeedsData.content)
                } else {
                    print("디코딩 모델 에러")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func myFeedsPublisher() -> AnyPublisher<[MyFeed], Never> {
        return myFeeds.eraseToAnyPublisher()
    }
    
    func getMyFeedsValue() -> [MyFeed] {
        return myFeeds.value
    }
}

//if let encodedURL = "/pairings?type=술".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
//    NetworkWrapper.shared.getBasicTask(stringURL: encodedURL) { result in
//        switch result {
//        case .success(let responseData):
//            if let pairingsData = try? self.jsonDecoder.decode(PairingModel.self, from: responseData) {
////                        let mappedData = self.mapper.snackModel(from: pairingsData.pairings ?? [])
////                        self.dataSource = mappedData
////                        self.setCompletedDrinkData.send(())
//                print(pairingsData)
//            } else {
//                print("디코딩 모델 에러")
//            }
//        case .failure(let error):
//            print(error)
//        }
//    }
//}

//        // 키체인 테스트
//        if KeychainStore.shared.read(label: "accessToken") != nil {
//            let viewController = SetUserNameViewController()
//            window?.rootViewController = viewController
//        } else {
//            let viewController = SignInViewController()SettingViewController
//            window?.rootViewController = viewController
//        }

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
