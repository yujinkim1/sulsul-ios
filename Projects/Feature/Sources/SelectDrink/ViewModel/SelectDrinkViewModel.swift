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
    private lazy var mapper = SnackModelMapper()
    
    private var cancelBag = Set<AnyCancellable>()
    private var dataSource = [SnackModel]() // viewModel에서 관리해보자
    
    private var tempDataSource: [SnackModel] = [.init(id: 1, type: "111", subtype: "111", name: "1", image: "111", description: "111", isSelect: false, highlightedText: "111"),
                                            .init(id: 1, type: "111", subtype: "111", name: "2", image: "111", description: "111", isSelect: false, highlightedText: "111"),
                                            .init(id: 1, type: "111", subtype: "111", name: "3", image: "111", description: "111", isSelect: false, highlightedText: "111"),
                                            .init(id: 1, type: "111", subtype: "111", name: "4", image: "111", description: "111", isSelect: false, highlightedText: "111"),
                                            .init(id: 1, type: "111", subtype: "111", name: "5", image: "111", description: "111", isSelect: false, highlightedText: "111"),
                                            .init(id: 1, type: "111", subtype: "111", name: "6", image: "111", description: "111", isSelect: false, highlightedText: "111"),
                                            .init(id: 1, type: "111", subtype: "111", name: "7", image: "111", description: "111", isSelect: false, highlightedText: "111"),
                                                .init(id: 1, type: "111", subtype: "111", name: "8", image: "111", description: "111", isSelect: false, highlightedText: "111"),
                                                .init(id: 1, type: "111", subtype: "111", name: "9", image: "111", description: "111", isSelect: false, highlightedText: "111"),
                                                .init(id: 1, type: "111", subtype: "111", name: "q0", image: "111", description: "111", isSelect: false, highlightedText: "111"),
                                                .init(id: 1, type: "111", subtype: "111", name: "11", image: "111", description: "111", isSelect: false, highlightedText: "111"),
                                                .init(id: 1, type: "111", subtype: "111", name: "12", image: "111", description: "111", isSelect: false, highlightedText: "111"),
                                                .init(id: 1, type: "111", subtype: "111", name: "13", image: "111", description: "111", isSelect: false, highlightedText: "111")
    ]
    private var selectedDrink = [SnackModel]()
    private var currentSelectedDrink = PassthroughSubject<Int, Never>()
    private var countSelectedDrink = PassthroughSubject<Int, Never>()
    
    
    private var canSelectedValue: Bool = true
    
    var selectDrinkCount: Int = 0
    
    init() {
        bind()
    }
    
    private func bind() {
        sendPairingsValue()

    }
    
    func sendPairingsValue() {
        if let encodedURL = "/pairings?type=술".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            NetworkWrapper.shared.getBasicTask(stringURL: encodedURL) { result in
                switch result {
                case .success(let responseData):
                    if let pairingsData = try? self.jsonDecoder.decode(PairingModel.self, from: responseData) {
                        let mappedData = self.mapper.snackModel(from: pairingsData.pairings ?? [])
                        self.dataSource = mappedData
                    } else {
                        print("디코딩 모델 에러")
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func dataSourceCount() -> Int {
        return tempDataSource.count
    }
    
    func getDataSource(_ index: Int) -> SnackModel {
        return tempDataSource[index]
    }
    
    func selectDataSource(_ index: Int) {
        tempDataSource[index].isSelect.toggle()
        verifySelectedCell(tempDataSource)
    }
    
    func drinkIsSelected(_ model: Pairing) {
        
//        if let index = selectedDrink.firstIndex(where: { $0.id == model.id }) {
//            selectedDrink.remove(at: index)
//        } else {
//            selectedDrink.append(model)
//        }
//        if selectedDrink.count < 4 {
//            countSelectedDrink.send(selectedDrink.count)
//        } else {
//            canSelectedValue = false
//        }
    }
    
    // 셀 하나 클릭될때마다 이거 실행시켜
    func verifySelectedCell(_ models: [SnackModel]) {
        let selectedItemCount = tempDataSource.filter { $0.isSelect == true }.count
        currentSelectedDrink.send(selectedItemCount)
    }
    
    func currentSelectedDrinkPublisher() -> AnyPublisher<Int, Never> {
        return currentSelectedDrink.eraseToAnyPublisher()
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
