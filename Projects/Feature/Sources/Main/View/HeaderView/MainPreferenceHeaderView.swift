//
//  MainPreferenceHeaderView.swift
//  Feature
//
//  Created by 이범준 on 3/1/24.
//

import UIKit
import DesignSystem

final class MainPreferenceHeaderView: UICollectionReusableView {
    private lazy var containerView = UIView().then({
        $0.backgroundColor = .white
    })
    
    private lazy var titleLabel = UILabel().then({
        $0.text = "소주랑 어울리는\n안주로 골라봤어요"
        $0.font = Font.bold(size: 28)
        $0.textColor = DesignSystemAsset.gray900.color
        $0.numberOfLines = 0
    })
    
    private lazy var preferecneCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.registerCell(MainPreferenceCell.self)
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        makeConstraints()
        setupIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func addViews() {
        addSubview(containerView)
        containerView.addSubviews([titleLabel,
                                   preferecneCollectionView])
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        preferecneCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 10))
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupIfNeeded() {
        
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
             let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(72), heightDimension: .absolute(32))
             let item = NSCollectionLayoutItem(layoutSize: itemSize)

             let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(72), heightDimension: .absolute(32))
             let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

             let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
             return section
         }
    }
    
    func updateUI(_ temp: Int) {
        if temp == 0 {
            preferecneCollectionView.isHidden = false
        } else {
            preferecneCollectionView.isHidden = true
        }
    }
}

extension MainPreferenceHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(MainPreferenceCell.self, indexPath: indexPath) else { return .init() }
        return cell
    }
}
