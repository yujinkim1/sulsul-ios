//
//  AddSnackViewModel.swift
//  Feature
//
//  Created by 김유진 on 2024/01/03.
//

import Combine
import Foundation
import Service

final class AddSnackViewModel {
    private lazy var jsonDecoder = JSONDecoder()
    
    // MARK: Output
    private lazy var goNextPage = PassthroughSubject<Void, Never>()
    private lazy var updateSelectedSnackSort = PassthroughSubject<String, Never>()
    private lazy var snackSortModels: [SnackSortModel] = [.init(name: "패스트푸드", isSelect: false),
                                                          .init(name: "고기류", isSelect: false),
                                                          .init(name: "생선류", isSelect: false),
                                                          .init(name: "요리류", isSelect: false),
                                                          .init(name: "면류", isSelect: false),
                                                          .init(name: "탕류", isSelect: false),
                                                          .init(name: "튀김류", isSelect: false),
                                                          .init(name: "마른안주/과일", isSelect: false)]
    
    // MARK: Input Method
    func updateSelectStatus(in index: IndexPath) {
        if let beforeSelectedModelIndex = snackSortModels.firstIndex(where: { $0.isSelect == true }) {
            snackSortModels[beforeSelectedModelIndex].isSelect = false
        }
        
        snackSortModels[index.row].isSelect = true
        updateSelectedSnackSort.send(snackSortModels[index.row].name)
    }
    
    func submitAddedSnack(_ name: String, _ sort: String?) {
        requestPOSTaddSnack(.init(type: "술", subtype: sort ?? "", name: name))
    }
    
    // MARK: Output Method
    func snackSorts() -> [SnackSortModel] {
        return snackSortModels
    }
    
    func snackSort(in index: IndexPath) -> SnackSortModel {
        return snackSortModels[index.row]
    }
    
    func shoudUpdateSelectedSnackSort() -> AnyPublisher<String, Never> {
        return updateSelectedSnackSort.eraseToAnyPublisher()
    }
    
    func shouldGoNextPage() -> AnyPublisher<Void, Never> {
        return goNextPage.eraseToAnyPublisher()
    }
}

extension AddSnackViewModel {
    private func requestPOSTaddSnack(_ requestModel: AddSnackRequestModel) {
        var parameters: [String: Any] = [:]
        parameters["type"] = requestModel.type
        parameters["subtype"] = requestModel.subtype
        parameters["name"] = requestModel.name

        NetworkWrapper.shared.postBasicTask(stringURL: "/pairings/requests", parameters: parameters) { [weak self] result in
            switch result {
            case .success(let responseData):
                self?.goNextPage.send(())
            case .failure(let error):
                print("[/pairings/requests] Fail : \(error)")
            }
        }
    }
}
