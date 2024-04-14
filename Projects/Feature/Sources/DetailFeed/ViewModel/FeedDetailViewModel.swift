//
//  FeedDetailViewModel.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-10.
//

import Combine
import Foundation
import Service
import Alamofire

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
        
        requestFeedDetail()
        
        pairingDrinkID
            .sink { [weak self] value in
                self?.requestPairingDrink(value)
            }
            .store(in: &cancelBag)
        
        pairingSnackID
            .sink { [weak self] value in
                self?.requestPairingSnack(value)
            }
            .store(in: &cancelBag)
    }
    
    public func requestFeedDetail() {
        guard let accessToken = KeychainStore.shared.read(label: "accessToken")
        else { return }
        debugPrint("\(#function): User accessToken is \(accessToken)")
        
        var headers: HTTPHeaders? = nil
        
        if UserDefaultsUtil.shared.isLogin() {
            headers = [
                "Content-Type": "application/json",
                "Authorization": "Baerer " + accessToken
            ]
        }
        
        networkWrapper.getBasicTask(stringURL: "/feeds/\(feedID)", header: headers) { [weak self] result in
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
    
    private func requestPairingDrink(_ alcoholPairingID: Int) {
        networkWrapper.getBasicTask(stringURL: "/pairings/\(alcoholPairingID)") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if let data = try? jsonDecoder.decode(Pairings.self, from: response) {
                    guard let drinkName = data.name else { return }
                    self.pairingDrinkName.send(drinkName)
                }
            case .failure(let error):
                print("\(#function): \(error)")
            }
        }
    }
    
    private func requestPairingSnack(_ foodPairingID: Int) {
        networkWrapper.getBasicTask(stringURL: "/pairings/\(foodPairingID)") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if let data = try? jsonDecoder.decode(Pairings.self, from: response) {
                    guard let snackName = data.name else { return }
                    self.pairingSnackName.send(snackName)
                }
            case .failure(let error):
                print("\(#function): \(error)")
            }
        }
    }
    
    public func requestLikeFeed(_ feedID: Int) {
        NetworkWrapper.shared.postBasicTask(stringURL: "/feeds/\(feedID)/like", needToken: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    let data = try self.jsonDecoder.decode(RandomFeedModel.Heart.self, from: response)
                    
                    self.isLiked.send(data.is_liked)
                    debugPrint("\(#function): Decoding success, \(data)")
                } catch {
                    debugPrint("\(#function): Decoding failed, Reason is: \(error.localizedDescription)")
                }
            case .failure(let error):
                debugPrint("\(#function): Request failed, Reason is: \(error.localizedDescription)")
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
