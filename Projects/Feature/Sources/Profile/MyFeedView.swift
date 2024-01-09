//
//  MyFeedView.swift
//  Feature
//
//  Created by 이범준 on 2024/01/08.
//

import UIKit
import Combine
import DesignSystem

class MyFeedView: UIView {
    
    private var tempCount = 0
    
    private var cancelBag = Set<AnyCancellable>()
//    private var viewModel: BeneficiaryViewModel
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then({
        $0.registerCell(NoDataCell.self)
        $0.registerCell(MyFeedCell.self)
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.dataSource = self
    })
    
    override init(frame: CGRect = .zero/*, viewModel: BeneficiaryViewModel*/) {
//        self.viewModel = viewModel
        super.init(frame: frame)
        addViews()
        makeConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        
    }
    
    func addViews() {
        addSubviews([collectionView])
    }
    
    func makeConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(moderateScale(number: 18))
            $0.leading.equalToSuperview().offset(moderateScale(number: 20))
            $0.trailing.equalToSuperview().offset(moderateScale(number: -20))
            $0.bottom.equalToSuperview()
        }
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in

            //TODO: - 수정 필요
            let itemHeight: CGFloat = (self.tempCount == 0) ? 80 + 133 + 80 : 220
            let itemWidth: CGFloat = (self.tempCount == 0) ? 1 : 1/2
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemWidth),
                                                  heightDimension: .absolute(moderateScale(number: itemHeight)))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
        
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(moderateScale(number: itemHeight)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.interGroupSpacing = 10
            
            return section
        }
    }
}

extension MyFeedView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModel.getBeneficiaryCountryList().count + 1
        if self.tempCount == 0 {
            // MARK: - 빈 셀일때
            return 1
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.tempCount == 0 {
            guard let cell = collectionView.dequeueReusableCell(NoDataCell.self, indexPath: indexPath) else { return .init() }
            cell.updateView(withType: .myFeed)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(LikeFeedCell.self, indexPath: indexPath) else { return .init() }
            return cell
        }
    }
}
