//
//  RankingViewModel.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-07.
//

import Foundation

final class RankingViewModel {
    
    private var datasource: [RankingDrink] = []
    
    func dataSourceCount() -> Int {
        return datasource.count
    }
    
    func getDataSource(_ index: Int) -> RankingDrink {
        let dummy = RankingDrink.dummies
        datasource[index] = dummy[index]
        return datasource[index]
    }
}
