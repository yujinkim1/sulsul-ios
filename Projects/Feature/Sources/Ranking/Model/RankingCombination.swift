//
//  RankingCombination.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-07.
//

import Foundation

struct RankingCombination {
    let drink: String
    let snack: String
}

#if DEBUG
extension RankingCombination {
    static var dummies = [
        RankingCombination(drink: "참이슬 후레쉬", snack: "삼겹살"),
        RankingCombination(drink: "참이슬 후레쉬", snack: "오겹살"),
        RankingCombination(drink: "참이슬 후레쉬", snack: "육겹살"),
        RankingCombination(drink: "G7 까베르네 소비뇽", snack: "칠겹살"),
        RankingCombination(drink: "참이슬 후레쉬", snack: "팔겹살")
    ]
}
#endif
