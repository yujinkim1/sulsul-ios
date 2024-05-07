//
//  CombineFeedViewController.swift
//  Feature
//
//  Created by 이범준 on 2024/05/07.
//

import UIKit
import DesignSystem
import Combine

public final class CombineFeedViewController: HiddenTabBarBaseViewController {
    var coordinator: Coordinator?
    private var cancelBag = Set<AnyCancellable>()
    
//    private let viewModel:
    
//    init() {
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    private lazy var topHeaderView = BaseTopView()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(collectionViewIsRefreshed) , for: .valueChanged)
        
        return refreshControl
    }()
    
    private lazy var CombineFeedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then({
        $0.registerCell(MainDifferenceCell.self)
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
        $0.refreshControl = refreshControl
    })
    
    public override func addViews() {
        view.addSubviews([topHeaderView,
                          CombineFeedCollectionView])
    }
    
    public override func makeConstraints() {
        topHeaderView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 52))
            $0.width.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        CombineFeedCollectionView.snp.makeConstraints {
            $0.top.equalTo(topHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] _, _ in
            let itemHeight: CGFloat = 416.86
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(moderateScale(number: itemHeight)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(moderateScale(number: itemHeight)))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
    }
    
    @objc
    private func collectionViewIsRefreshed() {
        refreshControl.endRefreshing()
    }
}

extension CombineFeedViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(MainDifferenceCell.self, indexPath: indexPath) else { return .init() }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3 // MARK: - 임시값
    }
}
