//
//  SelectSnackViewModel.swift
//  Feature
//
//  Created by 김유진 on 2023/12/09.
//

import Combine
import Foundation
import Service

final class SelectSnackViewModel {
    private lazy var jsonDecoder = JSONDecoder()
    
    // MARK: Output Subject
    private lazy var snackSubject = CurrentValueSubject<PairingModel, Never>(.init())
    
    init() {
        requestSnackList()
    }
    
    private func requestSnackList() {
        if let encodedURL = "/pairings?type=안주".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            NetworkWrapper.shared.getBasicTask(stringURL: encodedURL) { [weak self] result in
                switch result {
                case .success(let responseData):
                    if let pairingsData = try? self?.jsonDecoder.decode(PairingModel.self, from: responseData) {
                        self?.snackSubject.send(pairingsData)
                    } else {
                        print("[/pairings] Fail Decode")
                    }
                case .failure(let error):
                    print("[/pairings] Fail : \(error)")
                }
            }
        }
    }
    
    func snackPublisher() -> AnyPublisher<PairingModel, Never> {
        return snackSubject.dropFirst().eraseToAnyPublisher()
    }
}

