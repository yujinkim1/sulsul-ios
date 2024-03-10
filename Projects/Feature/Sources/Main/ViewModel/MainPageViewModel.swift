//
//  MainPageViewModel.swift
//  Feature
//
//  Created by 이범준 on 3/10/24.
//

import Foundation
import Combine
import Alamofire
import Service

struct MainPageViewModel {
    private var cancelBag = Set<AnyCancellable>()
    
//    private let popularFeeds = CurrentValueSubject<[
    
    init() {
        getPopularFeeds()
    }
    
    func getPopularFeeds() {
        guard let accessToken = KeychainStore.shared.read(label: "accessToken") else { return }
        
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken,
            "order_by_popular": "true"
        ]
        
        NetworkWrapper.shared.getBasicTask(stringURL: "/feeds/popular", header: headers) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
}
