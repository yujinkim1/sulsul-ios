//
//  DetailFeedViewModel.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-10.
//

import Combine
import Foundation
import Service

public final class DetailFeedViewModel {
    private let jsonDecoder = JSONDecoder()
    
    private var feedID: Int
    private var cancelBag = Set<AnyCancellable>()
    private var detailFeedSubject = PassthroughSubject<Feed, Never>()
    private var feedImageSubject = PassthroughSubject<FeedImages, Never>()
    private var detailFeedImageSubject = PassthroughSubject<[String], Never>()
    private var drinkNameSubject = PassthroughSubject<String, Never>()
    private var snackNameSubject = PassthroughSubject<String, Never>()
    private var feedImageDatasource: [String] = []
    
    var feedDatasource: Feed?
    
    public init(feedID: Int) {
        self.feedID = feedID
        requestFeedImages()
    }
    
    public func requestFeedImages() {
        print("DetailFeedViewModel.requestFeedImages() called.")
        
        NetworkWrapper.shared.getBasicTask(stringURL: "/feeds/\(feedID)") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if let data = try? jsonDecoder.decode(FeedImages.self, from: response) {
                    print("DetailFeedViewModel.requestFeedImages(): \(data)")
                    self.feedImageSubject.send(data)
                }
            case .failure(let error):
                print("DetailFeedViewModel.requestFeedImages(): \(error)")
            }
        }
    }
    
    public func requestDetailFeed() {
        print("DetailFeedViewModel.requestDetailFeed() called")
        NetworkWrapper.shared.getBasicTask(stringURL: "/feeds/\(feedID)") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if let data = try? self.jsonDecoder.decode(Feed.self, from: response) {
                    print("DetailFeedViewModel.requestDetailFeed(): \(data)")
                    self.feedDatasource = data
                    guard feedDatasource != nil else { return }
                    self.detailFeedSubject.send(feedDatasource!)
                    
                    requestParingDrink(data.alcoholPairingIds.first ?? 0)
                    requestParingSnack(data.foodPairingIds.first ?? 0)
                }
            case .failure(let error):
                print("DetailFeedViewModel.requestDetailFeed(): \(error)")
            }
        }
    }
    
    public func requestParingDrink(_ alcoholPairingID: Int) {
        let id = alcoholPairingID
        
        NetworkWrapper.shared.getBasicTask(stringURL: "/pairings/\(id)") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if let data = try? jsonDecoder.decode(Pairings.self, from: response) {
                    print("DetailFeedViewModel.requestParingDrink(): \(data)")
                    self.drinkNameSubject.send(data.name ?? "")
                }
            case .failure(let error):
                print("DetailFeedViewModel.requestParingDrink(): \(error)")
            }
        }
    }
    
    public func requestParingSnack(_ foodPairingID: Int) {
        let id = foodPairingID
        
        NetworkWrapper.shared.getBasicTask(stringURL: "/pairings/\(id)") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if let data = try? jsonDecoder.decode(Pairings.self, from: response) {
                    print("DetailFeedViewModel.requestParingSnack(): \(data)")
                    self.snackNameSubject.send(data.name ?? "")
                }
            case .failure(let error):
                print("DetailFeedViewModel.requestParingSnack(): \(error)")
            }
        }
    }
    
    public func imageDatasourceCount() -> Int {
        return feedImageDatasource.count
    }
    
    var detailFeedPublisher: AnyPublisher<Feed, Never> {
        return detailFeedSubject.eraseToAnyPublisher()
    }
    
    var feedImagePublisher: AnyPublisher<FeedImages, Never> {
        return feedImageSubject.eraseToAnyPublisher()
    }
    
    var pairingDrinkPublisher: AnyPublisher<String, Never> {
        return drinkNameSubject.eraseToAnyPublisher()
    }
    
    var imagePublisher: AnyPublisher<[String], Never> {
        return detailFeedImageSubject.eraseToAnyPublisher()
    }
}
