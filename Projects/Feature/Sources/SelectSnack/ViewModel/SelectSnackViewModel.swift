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
    
    // MARK: 모든 간식 배열에서 사용자가 선택한 간식을 찾아 isSelect 상태를 true로 업데이트해주는 함수
    func snackArrayWithSelected(_ allSnackArray: [Pairing], _ visibleSnackArray: [Pairing]) -> [Pairing] {
        var allSnackArrayWithSelected: [Pairing] = allSnackArray
        print("|| \(visibleSnackArray.first{$0.name == "피자"})")
        allSnackArrayWithSelected.enumerated().forEach { index, snack in
            if let visibleSnack = visibleSnackArray.first(where: { $0.name == snack.name }),
               let isSelected = visibleSnack.isSelect, isSelected {
                allSnackArrayWithSelected[index].isSelect = true
            }
        }
        
        return allSnackArrayWithSelected
    }
}

