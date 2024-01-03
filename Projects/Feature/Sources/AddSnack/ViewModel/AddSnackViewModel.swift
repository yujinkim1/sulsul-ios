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
    
    // MARK: Output
    private lazy var snackSortModels: [SnackSortModel] = [.init(name: "패스트푸드", isSelect: false),
                                                          .init(name: "고기류", isSelect: false),
                                                          .init(name: "생선류", isSelect: false),
                                                          .init(name: "요리류", isSelect: false),
                                                          .init(name: "면류", isSelect: false),
                                                          .init(name: "탕류", isSelect: false),
                                                          .init(name: "튀김류", isSelect: false),
                                                          .init(name: "마른안주/과일", isSelect: false)]
    
    private lazy var updateSelectedSnackSort = PassthroughSubject<String, Never>()
    
    // MARK: Input Method
    func updateSelectStatus(in index: IndexPath) {
        if let beforeSelectedModelIndex = snackSortModels.firstIndex(where: { $0.isSelect == true }) {
            snackSortModels[beforeSelectedModelIndex].isSelect = false
        }
        
        snackSortModels[index.row].isSelect = true
        updateSelectedSnackSort.send(snackSortModels[index.row].name)
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
}
