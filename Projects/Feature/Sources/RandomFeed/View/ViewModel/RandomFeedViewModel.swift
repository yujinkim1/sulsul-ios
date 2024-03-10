//
//  RandomFeedViewModel.swift
//  Feature
//
//  Created by 김유진 on 3/8/24.
//

import Foundation
import Service
import Combine

final class RandomFeedViewModel {
    private lazy var jsonDeoder = JSONDecoder()
    
    private var cancelBag = Set<AnyCancellable>()
    
    let errorSubject = CurrentValueSubject<String, Never>("")
    var randomFeeds: [RandomFeedModel.Feed] = []
    
    private lazy var excludeIds: [Int] = []

    // MARK: trigger
    let loadRandomFeed = CurrentValueSubject<RandomFeedModel.Request, Never>(.init(exclude_feed_ids: ""))
    private lazy var updateHeart = PassthroughSubject<Void, Never>()
    
    // MARK: output
    private let reloadRandomFeeds = CurrentValueSubject<Void, Never>(())
    
    init() {
        loadRandomFeed
            .flatMap(requestRandomFeed(_:))
            .sink { [weak self] randomFeeds in
                guard let selfRef = self else { return }
                
                self?.excludeIds += selfRef.excludeIds + randomFeeds.ids_list
                self?.randomFeeds += randomFeeds.feeds
                self?.reloadRandomFeeds.send(())
            }
            .store(in: &cancelBag)
        
        updateHeart
    }
    
    func didTabHeart() {
        
    }
    
    func loadMoreData() {
        let commaSeparatedString = excludeIds.map { String($0) }.joined(separator: ",")
        
        loadRandomFeed.send(.init(exclude_feed_ids: commaSeparatedString))
    }
    
    func reloadData() -> AnyPublisher<Void, Never> {
        return reloadRandomFeeds.dropFirst().eraseToAnyPublisher()
    }
    
    private func requestRandomFeed(_ request: RandomFeedModel.Request) -> AnyPublisher<RandomFeedModel.Feeds, Never> {
        return Future<RandomFeedModel.Feeds, Never> { promise in
            NetworkWrapper.shared.getBasicTask(stringURL: "/feeds/random?exclude_feed_ids=2%2C4&size=6") { [weak self] result in
                guard let selfRef = self else { return }
                
                switch result {
                case .success(let success):
                    let decoder = JSONDecoder()
                    
                    if let data = try? decoder.decode(RandomFeedModel.Feeds.self, from: success) {
                        return promise(.success(data))
                    } else {
                        print("[/feeds/random] fail Decoding")
                        return selfRef.errorSubject.send("[/feeds/random] fail Decoding")
                    }
                case .failure(let failure):
                    print("[/feeds/random] fail API")
                    return selfRef.errorSubject.send("[/feeds/random] fail API")
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
