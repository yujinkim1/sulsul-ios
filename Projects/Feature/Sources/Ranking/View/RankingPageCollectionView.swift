//
//  RankingPageCollectionView.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-05.
//

import DesignSystem
import UIKit

internal protocol PageTabBarDelegate: AnyObject {
    func scrollToIndex(to index: Int)
}

final class RankingPageCollectionView: UICollectionView {
    weak var pageTabBarDelegate: PageTabBarDelegate?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
