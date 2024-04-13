//
//  FeedDetailViewModel.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-10.
//

import Combine
import Foundation
import Service

public final class FeedDetailViewModel {
    var feedID: Int
    
    private var cancelBag = Set<AnyCancellable>()
    
    private let jsonDecoder = JSONDecoder()
    private let networkWrapper = NetworkWrapper.shared
    /// 현재 피드 ID에 대한 상세 데이터
    private var detailSubject = PassthroughSubject<FeedDetail, Never>()
    /// 현재 피드 ID에 대한 이미지
    private var feedImages = PassthroughSubject<[String], Never>()
    private var numberOfFeedImages = CurrentValueSubject<Int, Never>(0)
    /// 현재 피드가 포함하고 있는 댓글 개수
    private var numberOfComments = CurrentValueSubject<Int, Never>(0)
    /// 현재 피드의 페어링 주류 이름
    private var pairingDrinkName = CurrentValueSubject<String, Never>("")
    /// 현재 피드의 페어링 안주 이름
    private var pairingSnackName = CurrentValueSubject<String, Never>("")
    
    private var pairingDrinkID = CurrentValueSubject<Int, Never>(0)
    private var pairingSnackID = CurrentValueSubject<Int, Never>(0)
    private let isLiked = CurrentValueSubject<Bool, Never>(false)
    
    /// 테스트
    let loadFeedDetail = PassthroughSubject<Int, Never>()
    
    public init(feedID: Int) {
        self.feedID = feedID
//        requestFeedDetail()
    }
    
//    public func requestFeedDetail() {
//        NetworkWrapper.shared.getBasicTask(stringURL: "/feeds/\(feedID)") { [weak self] result in
//            guard let self = self else { return }
//            
//            switch result {
//            case .success(let response):
//                do {
//                    let data = try? self.jsonDecoder.decode(DetailFeed.Feed.self, from: response)
//                    print("DetailFeedViewModel.requestDetailFeed(): \(String(describing: data))")
//                    
//                    self.detailSubject.send(data!)
//                    self.numberOfComments.send(data!.commentCount)
//                    
//                    guard let alcoholPairingID = data?.alcoholPairingIDs.first,
//                          let snackPairingID = data?.snackPairingIDs.first
//                    else { return }
//                    
//                    self.requestParingDrink(alcoholPairingID)
//                    self.requestParingSnack(snackPairingID)
//                } catch {
//                    print("Error decoding feed data: \(error)")
//                }
//            case .failure(let error):
//                print("DetailFeedViewModel.requestDetailFeed(): \(error)")
//            }
//        }
//    }
    
    public func requestFeedDetail() {
        networkWrapper.getBasicTask(stringURL: "/feeds/\(feedID)") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    let data = try self.jsonDecoder.decode(FeedDetail.self, from: response)
                    
                    self.detailSubject.send(data)
                    self.numberOfComments.send(data.commentCount)
                    self.isLiked.send(data.isLiked)
                    
                    guard let alcoholPairingID = data.alcoholPairingIDs.first,
                          let snackPairingID = data.snackPairingIDs.first
                    else { return }
                    
                    self.pairingDrinkID.send(alcoholPairingID)
                    self.pairingSnackID.send(snackPairingID)
                    
                    debugPrint("\(#function): \(data)")
                } catch {
                    debugPrint("\(#function): Decoding failed, Reason is: \(error.localizedDescription)")
                }
            case .failure(let error):
                debugPrint("\(self): Request failed, Reason is: \(error.localizedDescription)")
            }
        }
    }
    
//    private func requestPairingName(withPairingID alcoholPairingIDs: [Int], foodPairingIDs: [Int]) {
//        var publishers: [AnyPublisher<String, Never>] = []
//        
//        highvalueForAlcohol: for alcoholPairingID in alcoholPairingIDs {
//            let publisher = networkWrapper.getBasicTask(stringURL: "pairings/\(alcoholPairingID)") { [weak self] result in
//                guard let self = self else { return }
//                
//            }
//        }
//            
//        highvalueForSnack: for foodPairingID in foodPairingIDs {
//            <#body#>
//        }
//    }
    
    private func requestParingDrink(_ alcoholPairingID: Int) {
        networkWrapper.getBasicTask(stringURL: "/pairings/\(alcoholPairingID)") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if let data = try? jsonDecoder.decode(Pairings.self, from: response) {
                    guard let drinkName = data.name else { return }
                    self.pairingDrinkName.send(drinkName)
                }
            case .failure(let error):
                print("DetailFeedViewModel.requestPairingDrink(): \(error)")
            }
        }
    }
    
    private func requestParingSnack(_ foodPairingID: Int) {
        networkWrapper.getBasicTask(stringURL: "/pairings/\(foodPairingID)") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if let data = try? jsonDecoder.decode(Pairings.self, from: response) {
                    guard let snackName = data.name else { return }
                    self.pairingSnackName.send(snackName)
                }
            case .failure(let error):
                print("DetailFeedViewModel.requestPairingSnack(): \(error)")
            }
        }
    }
    
    public func requestLikeFeed(_ feedID: Int) {
        NetworkWrapper.shared.postBasicTask(stringURL: "/feeds/\(feedID)/like", needToken: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if let data = try? self.jsonDecoder.decode(RandomFeedModel.Heart.self, from: response) {
                    // 결과 반영
                }
            case .failure(let error):
                debugPrint("\(self): Request failed.")
            }
        }
    }
    
    public func fetchCommentCount() -> Int {
        return numberOfComments.value
    }
    
    var pairingDrinkPublisher: AnyPublisher<String, Never> {
        return pairingDrinkName.eraseToAnyPublisher()
    }
    
    var pairingSnackPublisher: AnyPublisher<String, Never> {
        return pairingSnackName.eraseToAnyPublisher()
    }
    
    var isLikedPublisher: AnyPublisher<Bool, Never> {
        return isLiked.eraseToAnyPublisher()
    }
    
    var detailFeedPublisher: AnyPublisher<FeedDetail, Never> {
        return detailSubject.eraseToAnyPublisher()
    }
    
    var feedImagePublisher: AnyPublisher<[String], Never> {
        return feedImages.eraseToAnyPublisher()
    }
}
