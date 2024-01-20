//
//  RankingViewModel.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-07.
//

import Combine
import Foundation
import Service

final class RankingViewModel {
    
    private let jsonDecoder = JSONDecoder()
    var cancelBag = Set<AnyCancellable>()
    
    @Published var rankingDrink: [RankingDrink] = []
    private var datasource: [RankingDrink] = []
    
    init() {
        requestRankingAlcohol()
    }
    
    public func requestRankingAlcohol() {
        NetworkWrapper.shared.getBasicTask(stringURL: "/ranks/alcohol") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let responseData):
                do {
                    let data = try self.jsonDecoder.decode(RankingDrink.self, from: responseData)
                    self.datasource = [data]
                    self.rankingDrink = self.datasource
                    print("디코딩 성공: \(rankingDrink)")
                } catch {
                    print("디코딩 에러: \(error)")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func dataSourceCount() -> Int {
        return rankingDrink.first?.ranking?.count ?? 0
    }
}
