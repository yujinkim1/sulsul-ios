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
    private var cancelBag = Set<AnyCancellable>()
    private let kindOfDrinks = PassthroughSubject<PairingModel, Never>()
    private var selectedDrink = [Pairing]()
    private var countSelectedDrink = PassthroughSubject<Int, Never>()
    
    
    private var canSelectedValue: Bool = true
    
    var selectDrinkCount: Int = 0
    
    init() {
        bind()
    }
    
    
    cell 모델 바꾸기 ㄱㄱ
    
    private func bind() {
        sendPairingsValue()

    }
    
    func sendPairingsValue() {
        if let encodedURL = "/pairings?type=술".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            NetworkWrapper.shared.getBasicTask(stringURL: encodedURL) { result in
                switch result {
                case .success(let responseData):
                    if let pairingsData = try? self.jsonDecoder.decode(PairingModel.self, from: responseData) {
                        self.kindOfDrinks.send(pairingsData)
                    } else {
                        print("디코딩 모델 에러")
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func pairingsValuePublisher() -> AnyPublisher<PairingModel, Never> {
        return kindOfDrinks.eraseToAnyPublisher()
    }
    
    func drinkIsSelected(_ model: Pairing) {
        
        if let index = selectedDrink.firstIndex(where: { $0.id == model.id }) {
            selectedDrink.remove(at: index)
        } else {
            selectedDrink.append(model)
        }
        if selectedDrink.count < 4 {
            countSelectedDrink.send(selectedDrink.count)
        } else {
            canSelectedValue = false
        }
    }
    
    func countSelectedDrinkPublisher() -> AnyPublisher<Int, Never> {
        return countSelectedDrink.eraseToAnyPublisher()
    }
    
    func getSelectedDrinkCount() -> Int {
        return selectedDrink.count
    }
    
    func getCanSelectedValue() -> Bool {
        return canSelectedValue
    }
}
