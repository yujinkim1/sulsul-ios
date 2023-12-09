//
//  SelectDrinkViewModel.swift
//  Feature
//
//  Created by 이범준 on 2023/11/23.
//

import Foundation
import Combine
import Service

final class SelectDrinkViewModel {
    private let jsonDecoder = JSONDecoder()
    private let pairingsValue = PassthroughSubject<PairingModel, Never>()
    init() {
        bind()
    }
    
    private func bind() {
        sendPairingsValue()
    }
    
    func sendPairingsValue() {
        NetworkWrapper.shared.getBasicTask(stringURL: "/pairings") { result in
            switch result {
            case .success(let responseData):
                if let pairingsData = try? self.jsonDecoder.decode(PairingModel.self, from: responseData) {
                    self.pairingsValue.send(pairingsData)
                } else {
                    print("디코딩 모델 에러")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func pairingsValuePublisher() -> AnyPublisher<PairingModel, Never> {
        return pairingsValue.eraseToAnyPublisher()
    }
}
