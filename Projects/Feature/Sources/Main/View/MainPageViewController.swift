//
//  MainPageViewController.swift
//  Feature
//
//  Created by 이범준 on 2/18/24.
//

import UIKit
import DesignSystem
import Service
import Combine
import Kingfisher

public final class MainPageViewController: BaseViewController {
    
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var topHeaderView = UIView()
    
    private lazy var searchTouchableIamgeView = TouchableImageView(frame: .zero).then({
        $0.image = UIImage(named: "common_search")
        $0.tintColor = DesignSystemAsset.gray900.color
    })
    
    private lazy var settingTouchableImageView = TouchableImageView(frame: .zero).then({
        $0.image = UIImage(named: "common_setting")
        $0.tintColor = DesignSystemAsset.gray900.color
    })
    
    private lazy var couponCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.registerSupplimentaryView(MainPreferenceHeaderView.self,
                                     supplementaryViewOfKind: .header)
//        $0.registerSupplimentaryView(LikeHeaderView.self,
//                                     supplementaryViewOfKind: .header)
//        $0.registerSupplimentaryView(DifferenceHeaderView.self,
//                                     supplementaryViewOfKind: .header)
        $0.registerCell(MainPreferenceCell.self)
//        $0.registerCell(MainLikeCell.self)
//        $0.registerCell(MainDifferenceCell.self)
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
//        NotificationCenter.default.addObserver(self, selector: #selector(profileIsChanged), name: NSNotification.Name("ProfileIsChanged"), object: nil)
        view.backgroundColor = DesignSystemAsset.black.color
        addViews()
        makeConstraints()
    }
    
    public override func addViews() {
        view.addSubviews([topHeaderView,
                          couponCollectionView])
        
        topHeaderView.addSubviews([searchTouchableIamgeView,
                                   settingTouchableImageView])
    }
    
    public override func makeConstraints() {
        topHeaderView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 52))
            $0.width.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        searchTouchableIamgeView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(settingTouchableImageView.snp.leading).offset(moderateScale(number: -12))
            $0.size.equalTo(moderateScale(number: 24))
        }
        settingTouchableImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(moderateScale(number: -20))
            $0.size.equalTo(moderateScale(number: 24))
        }
        couponCollectionView.snp.makeConstraints {
            $0.top.equalTo(topHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.bottom.equalToSuperview()
        }
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            switch sectionIndex {
            case 0:
                var itemHeight: CGFloat = 0
                
                itemHeight = 68
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(moderateScale(number: itemHeight)))
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(moderateScale(number: itemHeight)))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                    
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(moderateScale(number: 46)))
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
                section.boundarySupplementaryItems = [header]
                
                return section
//            case 1:
            default:
                return nil
            }
        }
    }
}

extension MainPageViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(MainPreferenceCell.self, indexPath: indexPath) else { return .init() }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            guard let registerHeaderView = collectionView.dequeueSupplimentaryView(MainPreferenceHeaderView.self, supplementaryViewOfKind: .header, indexPath: indexPath) else {
                return .init()
            }
            return registerHeaderView
        }
        return UICollectionReusableView()
    }
}
