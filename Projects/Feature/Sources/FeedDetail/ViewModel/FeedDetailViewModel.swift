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
    
    private let jsonDecoder = JSONDecoder()
    private let networkWrapper = NetworkWrapper.shared
    
    private var cancelBag = Set<AnyCancellable>()
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
    /// 주류, 안주 이름을 받아오기 위한 페어링 아이디 값
    private var pairingDrinkID = CurrentValueSubject<Int, Never>(0)
    private var pairingSnackID = CurrentValueSubject<Int, Never>(0)
    /// 좋아요 표시
    private let isLiked = CurrentValueSubject<Bool, Never>(false)
    /// 현재 피드와 관련된 다른 피드
    var relatedFeeds: [RelatedFeed] = []
    /// 현재 피드와 관련된 다른 피드 개수
    private var numberOfRelatedFeed = CurrentValueSubject<Int, Never>(0)
    
    public init(feedID: Int) {
        self.feedID = feedID
        
        requestFeedDetail()
        requestRelatedFeeds()
        
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
    
    func displayHashtags(withTags: [String]) {
        let userTags = ["#첫번째 #두번째 #이렇게_이어지면_하나의_태그로_처리"]
        
        var tags: [String] = []
        
        for tag in userTags {
            let split = tag.split(separator: "#", omittingEmptySubsequences: true)
            
            for tag in split {
                let trimmedTag = "#" + tag.trimmingCharacters(in: .whitespaces)
                tags.append(trimmedTag)
            }
        }
        print(tags)
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
                    debugPrint("\(#function): Decoding succeed, \(data)")
                } catch {
                    debugPrint("\(#function): Decoding failed, Reason is: \(error.localizedDescription)")
                }
            case .failure(let error):
                debugPrint("\(#function): Request failed, Reason is: \(error.localizedDescription)")
            }
        }
    }
    
    public func requestRelatedFeeds() {
        networkWrapper.getBasicTask(stringURL: "/feeds/\(feedID)/related-feeds?next_feed_id=0&size=6") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    let data = try self.jsonDecoder.decode(CursorPageResponse.self, from: response)
                    
                    self.relatedFeeds = data.content
                    self.numberOfRelatedFeed.send(data.content.count)
                    
                    debugPrint("\(#function): Decoding succeed, \(data)")
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
    
    public func fetchRelatedFeedCount() -> Int {
        return numberOfRelatedFeed.value
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

// MARK: - Request

extension FeedDetailViewModel {
    /// 연관 피드를 뷰에 표시하는 과정을 수행하는 메서드
    ///
    func viewWillDisplayRelatedFeeds() {}
    
    /// 사용자 태그를 뷰에 표시하는 과정을 수행하는 메서드
    ///
    func viewWillDisplayUserTags() {}
}
