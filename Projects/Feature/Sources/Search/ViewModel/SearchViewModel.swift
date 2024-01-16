//
//  SearchViewModel.swift
//  Feature
//
//  Created by 김유진 on 2024/01/15.
//

import Foundation
import DesignSystem
import Combine

final class SearchViewModel {
    private lazy var searchKeywordList: [String] = []
    
    private lazy var reloadCollectionViewSubject = PassthroughSubject<Void, Never>()
    
    func searchKeywords() -> [String] {
        return UserDefaultsUtil.shared.recentKeywordList() ?? []
    }
    
    func searchKeyword(_ index: Int) -> String {
        return searchKeywords()[index]
    }
    
    func removeSelectedKeyword(_ indexPath: IndexPath) {
        var updatedKeywords = searchKeywords()
        updatedKeywords.remove(at: indexPath.row)
        
        UserDefaultsUtil.shared.remove(key: .recentKeyword)
        UserDefaultsUtil.shared.setRecentKeywordList(updatedKeywords)
        
        reloadCollectionViewSubject.send(())
    }
    
    // MARK: Output Method
    func reloadCollectionViewPublisher() -> AnyPublisher<Void, Never> {
        return reloadCollectionViewSubject.eraseToAnyPublisher()
    }
    
    func keywordCount() -> Int {
        return searchKeywords().count
    }
}
