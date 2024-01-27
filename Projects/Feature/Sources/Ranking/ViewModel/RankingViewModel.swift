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
    var drinkDatasource: [Ranking] = []
    var combinationDatasource: [Ranking] = []
    var rankingBasePublisher: AnyPublisher<[Ranking], Never> {
        return rankingBaseSubject.eraseToAnyPublisher()
    }
    var rankingDrinkPublisher: AnyPublisher<[Ranking], Never> {
        return rankingDrinkSubject.eraseToAnyPublisher()
    }
    var rankingCombinationPublisher: AnyPublisher<[Ranking], Never> {
        return rankingCombinationSubject.eraseToAnyPublisher()
    }
    
    private var rankingBaseSubject = PassthroughSubject<[Ranking], Never>()
    private var rankingDrinkSubject = PassthroughSubject<[Ranking], Never>()
    private var rankingCombinationSubject = PassthroughSubject<[Ranking], Never>()
    
    init() {
        requestRankingAlcohol()
        requestRankingCombination()
    }
    
    public func requestRankingAlcohol() {
        NetworkWrapper.shared.getBasicTask(stringURL: "/ranks/alcohol") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let responseData):
                do {
                    let data = try self.jsonDecoder.decode(Ranking.self, from: responseData)
                    self.drinkDatasource = [data]
                    self.rankingDrinkSubject.send(self.drinkDatasource)
                    self.rankingBaseSubject.send(self.drinkDatasource)
                    print("디코딩 성공: \(self.drinkDatasource)")
                } catch {
                    print("디코딩 에러: \(error)")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func requestRankingCombination() {
        NetworkWrapper.shared.getBasicTask(stringURL: "/ranks/combinations") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let responseData):
                do {
                    let data = try self.jsonDecoder.decode(Ranking.self, from: responseData)
                    self.combinationDatasource = [data]
                    self.rankingCombinationSubject.send(self.combinationDatasource)
                    print("디코딩 성공: \(self.combinationDatasource)")
                } catch {
                    print("디코딩 에러: \(error)")
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    public func drinkDatasourceCount() -> Int {
        return drinkDatasource.first?.ranking?.count ?? 0
    }
    
    public func combinationDatasourceCount() -> Int {
        return combinationDatasource.first?.ranking?.count ?? 0
    }
}
