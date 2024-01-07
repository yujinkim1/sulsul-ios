//
//  RankingDrink.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-07.
//

import Foundation

struct RankingDrink {
    let name: String
    let rank: String
}

#if DEBUG
extension RankingDrink {
    static var dummies = [
        RankingDrink(name: "켈리", rank: "4"),
        RankingDrink(name: "참이슬 후레쉬", rank: "1"),
        RankingDrink(name: "새로", rank: "3"),
        RankingDrink(name: "G7 까베르네 소비뇽", rank: "2"),
        RankingDrink(name: "테라", rank: "5")
    ]
}
#endif
