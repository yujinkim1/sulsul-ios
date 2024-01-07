//
//  RankingDrinkPageView.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-05.
//

import DesignSystem
import UIKit

final class RankingDrinkPageView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RankingDrinkPageView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankingDrinkCell.reuseIdentifier, for: indexPath) as? RankingDrinkCell else { return UICollectionViewCell() }
        return cell
    }
}
