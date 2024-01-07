//
//  RankingDrinkCell.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-05.
//

import DesignSystem
import UIKit

final class RankingDrinkCell: UICollectionViewCell {
    static let reuseIdentifier = "RankingDrinkCell"
    
    // 셀 좌측 아이템 순위 라벨: rankLabel
    
    // rankLabel 하단에는 순위 변동 사항 라벨: variationLabel
    
    // variationStackView로 관리해야할 것으로 보임 (변동사항이 있을 경우 increase, decrease 이미지도 함께 보여줘야하기 때문에)
    
    // rankLabel과 variationLabel은 간격 4 우측으로 제품 이미지: drinkImageView
    
    // drinkImageView 간격 4 우측으로 제품 이름: drinkNameLabel
    
    // drinkNameLabel 상단 해당 제품의 tagStackView
}
