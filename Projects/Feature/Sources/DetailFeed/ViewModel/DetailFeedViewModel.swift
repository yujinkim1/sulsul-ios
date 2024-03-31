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
    var feedID: Int
    
    private let jsonDecoder = JSONDecoder()
    private var cancelBag = Set<AnyCancellable>()
    /// 현재 피드 ID에 대한 상세 데이터
    private var detailFeedSubject = PassthroughSubject<DetailFeed.Feed, Never>()
    /// 현재 피드 ID에 대한 이미지
    private var detailFeedImageSubject = PassthroughSubject<[String], Never>()
    /// 댓글 개수
    private var commentCountSubject = CurrentValueSubject<Int, Never>(0)
    /// 페어링 주류와 안주
    private var pairingDrinkSubject = CurrentValueSubject<String, Never>("")
    private var pairingSnackSubject = CurrentValueSubject<String, Never>("")
    
    public init(feedID: Int) {
        self.feedID = feedID
        
        requestDetailFeed()
    }
    
    public func requestDetailFeed() {
        NetworkWrapper.shared.getBasicTask(stringURL: "/feeds/\(feedID)") { [weak self] result in
            
            switch result {
            case .success(let response):
                do {
                    let data = try self?.jsonDecoder.decode(DetailFeed.Feed.self, from: response)
                    print("DetailFeedViewModel.requestDetailFeed(): \(String(describing: data))")
                    
                    self?.detailFeedSubject.send(data!)
                    self?.commentCountSubject.send(data!.commentCount)
                    
                    guard let alcoholPairingID = data?.alcoholPairingIDs.first,
                          let snackPairingID = data?.snackPairingIDs.first
                    else { return }
                    
                    self?.requestParingDrink(alcoholPairingID)
                    self?.requestParingSnack(snackPairingID)
                } catch {
                    print("Error decoding feed data: \(error)")
                }
            case .failure(let error):
                print("DetailFeedViewModel.requestDetailFeed(): \(error)")
            }
        }
    }
    
    private func requestParingDrink(_ alcoholPairingID: Int) {
        NetworkWrapper.shared.getBasicTask(stringURL: "/pairings/\(alcoholPairingID)") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if let data = try? jsonDecoder.decode(Pairings.self, from: response) {
                    guard let drinkName = data.name else { return }
                    self.pairingDrinkSubject.send(drinkName)
                }
            case .failure(let error):
                print("DetailFeedViewModel.requestPairingDrink(): \(error)")
            }
        }
    }
    
    private func requestParingSnack(_ foodPairingID: Int) {
        NetworkWrapper.shared.getBasicTask(stringURL: "/pairings/\(foodPairingID)") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if let data = try? jsonDecoder.decode(Pairings.self, from: response) {
                    guard let snackName = data.name else { return }
                    self.pairingSnackSubject.send(snackName)
                }
            case .failure(let error):
                print("DetailFeedViewModel.requestPairingSnack(): \(error)")
            }
        }
    }
    
    public func requestLike(_ feedID: Int) {
        NetworkWrapper.shared.postBasicTask(stringURL: "/feeds/\(feedID)/like") { result in
            // TODO: 좋아요 표시, 취소
        }
    }
    
    public func fetchCommentCount() -> Int {
        return commentCountSubject.value
    }
    
    var pairingDrinkPublisher: AnyPublisher<String, Never> {
        return pairingDrinkSubject.eraseToAnyPublisher()
    }
    
    var pairingSnackPublisher: AnyPublisher<String, Never> {
        return pairingSnackSubject.eraseToAnyPublisher()
    }
    
    var detailFeedPublisher: AnyPublisher<DetailFeed.Feed, Never> {
        return detailFeedSubject.eraseToAnyPublisher()
    }
    
    var feedImagePublisher: AnyPublisher<[String], Never> {
        return detailFeedImageSubject.eraseToAnyPublisher()
    }
}
