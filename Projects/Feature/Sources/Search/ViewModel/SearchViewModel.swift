//
//  SearchViewModel.swift
//  Feature
//
//  Created by 김유진 on 2024/01/15.
//

import Foundation
import Combine
import DesignSystem
import Service

struct SearchSectionModel {
    let headerTitle: String
    let totalCount: Int
    let unShowedCount: Int
    let showFooterLine: Bool
    let searchModel: [Pairing]
}

final class SearchViewModel {
    private lazy var jsonDecoder = JSONDecoder()
    private lazy var mapper = PairingModelMapper()
    
    private lazy var drinkList: [Pairing] = []
    private lazy var snackList: [Pairing] = []  
    private lazy var resultDrinkList: [Pairing] = []
    private lazy var resultSnackList: [Pairing] = []
    
    // MARK: Datasource
    private lazy var searchKeywordList: [String] = []
    lazy var searchSectionModel: [SearchSectionModel] = []
    
    // MARK: output
    lazy var reloadRecentKeywordData = PassthroughSubject<Void, Never>()
    lazy var reloadSearchData = PassthroughSubject<Void, Never>()
    
    init() {
        getPairings()
    }
    
    func search(text: String?) -> () {
        if let searchText = text {
            resultDrinkList = drinkList.filter({ $0.subtype?.contains(searchText) == true })
            resultSnackList = snackList.filter({ $0.subtype?.contains(searchText) == true })
            
            setSearchSectionModels()
            reloadSearchData.send(())
        }
    }
    
    func searchKeywords() -> [String] {
        return UserDefaultsUtil.shared.recentKeywordList() ?? []
    }
    
    func searchKeyword(_ index: Int) -> String {
        return searchKeywords()[index]
    }
    
    func removeSelectedKeyword(_ indexPath: IndexPath) {
        var updatedKeywords = searchKeywords()
        updatedKeywords.remove(at: indexPath.row)
        
        UserDefaultsUtil.shared.remove(.recentKeyword)
        UserDefaultsUtil.shared.setRecentKeywordList(updatedKeywords)
        
        reloadRecentKeywordData.send(())
    }
    
    // MARK: Output Method
    func keywordCount() -> Int {
        return searchKeywords().count
    }
}

extension SearchViewModel {
    private func getPairings() {
        if let encodedURL = "/pairings?type=전체".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            NetworkWrapper.shared.getBasicTask(stringURL: encodedURL) { [weak self] result in
                guard let selfRef = self else { return }
                
                switch result {
                case .success(let responseData):
                    if let pairingsData = try? selfRef.jsonDecoder.decode(PairingModel.self, from: responseData),
                       let parings = pairingsData.pairings {
                        
                        selfRef.drinkList = parings.filter{ $0.type == "술" }
                        selfRef.snackList = parings.filter{ $0.type == "안주" }
                    } else {
                        print("[/pairings] Fail Decode")
                    }
                case .failure(let error):
                    print("[/pairings] Fail : \(error)")
                }
            }
        }
    }
    
    private func getFeeds() {
        
    }
    
    private func setSearchSectionModels() {
        searchSectionModel = []
        
        if !resultDrinkList.isEmpty {
            let unShowedCount = drinkList.count > 3 ? drinkList.count - 1 : 0
            searchSectionModel.append(.init(headerTitle: "술",
                                            totalCount: resultDrinkList.count,
                                            unShowedCount: unShowedCount,
                                            showFooterLine: !resultSnackList.isEmpty,
                                            searchModel: resultDrinkList))
        }
        
        if !resultSnackList.isEmpty {
            let unShowedCount = snackList.count > 3 ? snackList.count - 1 : 0
            searchSectionModel.append(.init(headerTitle: "안주",
                                            totalCount: resultSnackList.count,
                                            unShowedCount: unShowedCount,
                                            showFooterLine: !resultDrinkList.isEmpty,
                                            searchModel: resultSnackList))
        }
    }
}
