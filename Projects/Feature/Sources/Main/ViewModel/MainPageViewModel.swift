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
    private let jsonDecoder = JSONDecoder()
    private let mainPageMapper = MainPageMapper()
    private let popularFeeds = CurrentValueSubject<[PopularFeed], Never> ([])
    
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
                if let popularFeedList = try? self.jsonDecoder.decode([RemotePopularFeedsItem].self, from: response) {
                    let mappedPopularFeeds = self.mainPageMapper.popularFeeds(from: popularFeedList)
                    popularFeeds.send(mappedPopularFeeds)
                } else {
                    print("디코딩 에러")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func popularFeedsPublisher() -> AnyPublisher<[PopularFeed] , Never> {
        return popularFeeds.eraseToAnyPublisher()
    }
}
