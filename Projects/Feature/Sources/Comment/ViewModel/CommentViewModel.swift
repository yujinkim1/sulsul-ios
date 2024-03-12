//
//  CommentViewModel.swift
//  Feature
//
//  Created by 김유진 on 3/13/24.
//

import Foundation
import Combine
import Service

final class CommentViewModel {
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: Datasource
    var comments: [Comment] = []
    
    // MARK: Output
    private lazy var errorSubject = CurrentValueSubject<NetworkError, Never>(NetworkError(message: "Init"))
    
    init(feedId: Int) {
        getComments(feedId)
            .sink { [weak self] comments in
                self?.comments = comments
            }
            .store(in: &cancelBag)
    }
    
    func errorPublisher() -> AnyPublisher<NetworkError, Never> {
        return errorSubject.dropFirst().eraseToAnyPublisher()
    }
    
    private func getComments(_ feedId: Int) -> AnyPublisher<[Comment], Never> {
        return Future<[Comment], Never> { promise in
            NetworkWrapper.shared.getBasicTask(stringURL: "/feeds/\(feedId)/comments") { [weak self] result in
                guard let selfRef = self else { return }
                
                switch result {
                case .success(let success):
                    let decoder = JSONDecoder()
                    
                    if let data = try? decoder.decode(CommentModel.self, from: success) {
                        return promise(.success(data.comments))
                    } else {
                        print("[/comments] fail Decoding")
                        return selfRef.errorSubject.send(.init(message: "[/comments] fail Decoding"))
                    }
                case .failure(let failure):
                    print("[/comments] fail API : \(failure)")
                    return selfRef.errorSubject.send(.init(message: "[/comments] fail API"))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
