//
//  CarouselCollectionView.swift
//  Feature
//
//  Created by Yujin Kim on 2024-04-19.
//

import UIKit
import DesignSystem

final class CarouselCollectionView: UICollectionView {
    // MARK: - Initializer
    //
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.reuseIdentifier)
        self.collectionViewLayout = createFlowLayout()
        self.layer.cornerRadius = CGFloat(20)
        self.layer.borderColor = .none
        self.layer.borderWidth = .zero
        self.layer.masksToBounds = true
        self.backgroundColor = .clear
        self.showsHorizontalScrollIndicator = false
        self.isPagingEnabled = true
        self.dataSource = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Custom method

extension CarouselCollectionView {
    private func createFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout().then {
            $0.scrollDirection = .horizontal
            $0.estimatedItemSize = CGSize(width: 353, height: 353)
            $0.minimumLineSpacing = 0
            $0.minimumInteritemSpacing = 0
            $0.invalidateLayout()
        }
        
        return flowLayout
    }
}

// MARK: - UICollectionView DataSource

extension CarouselCollectionView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.reuseIdentifier, for: indexPath) as? CarouselCell
        else { return .init() }
        
        return cell
    }
}
