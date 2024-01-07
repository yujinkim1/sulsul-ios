//
//  RankingViewController.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-05.
//

import DesignSystem
import UIKit

public final class RankingViewController: BaseViewController {
    var coordinator: RankingBaseCoordinator?
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "이번주 랭킹"
        $0.font = Font.bold(size: 28)
        $0.setTextLineHeight(height: 38)
        $0.textColor = DesignSystemAsset.white.color
    }
    
    private lazy var weekendLabel = UILabel().then {
        $0.text = "12/04 ~ 12/10"
        $0.font = Font.regular(size: 14)
        $0.setTextLineHeight(height: 22)
        $0.textColor = DesignSystemAsset.gray600.color
    }
    
    private lazy var flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    
    private lazy var rankingPageTabBarContainerView = UIView().then {
        $0.frame = .zero
    }
    
    private lazy var rankingPageTabBarView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.delegate = self
        $0.dataSource = self
        $0.register(RankingPageTabBarCell.self, forCellWithReuseIdentifier: RankingPageTabBarCell.reuseIdentifier)
    }
    
    private lazy var indicatorView = UIView().then {
        $0.backgroundColor = UIColor(red: 255/255, green: 182/255, blue: 2/255, alpha: 1)
    }
    
    public override func viewDidLoad() {
        overrideUserInterfaceStyle = .dark
        view.backgroundColor = DesignSystemAsset.black.color
        
        addViews()
        makeConstraints()
    }
    
    public override func addViews() {
        rankingPageTabBarContainerView.addSubview(rankingPageTabBarView)
        view.addSubviews([titleLabel, weekendLabel, rankingPageTabBarContainerView, indicatorView])
    }
    
    public override func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(moderateScale(number: 20))
            $0.top.equalToSuperview().offset(moderateScale(number: 52))
        }
        weekendLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(moderateScale(number: 8))
            $0.top.bottom.equalTo(titleLabel)
        }
        rankingPageTabBarContainerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.height.equalTo(moderateScale(number: 40))
        }
        rankingPageTabBarView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.bottom.equalToSuperview()
        }
        indicatorView.snp.makeConstraints {
            $0.height.equalTo(2)
            $0.width.equalTo(rankingPageTabBarView.snp.width).dividedBy(2)
            $0.top.equalTo(rankingPageTabBarContainerView.snp.bottom)
            $0.leading.equalTo(rankingPageTabBarView)
        }
    }
}

// MARK: - 페이지 탭바 CollectionView DataSource

extension RankingViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankingPageTabBarCell.reuseIdentifier, for: indexPath) as? RankingPageTabBarCell else { return UICollectionViewCell() }
        
        if indexPath.item == 0 {
            cell.configure(text: "술")
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
        
        if indexPath.item == 1 {
            cell.configure(text: "술+안주")
        }
        
        return cell
    }
}

// MARK: - 페이지 탭바 CollectionView 델리게이트

extension RankingViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemWidth = collectionView.bounds.width / CGFloat(2)
        let position = CGFloat(indexPath.item) * itemWidth
        
        UIView.animate(withDuration: 0.3) {
            self.indicatorView.snp.remakeConstraints {
                $0.height.equalTo(2)
                $0.width.equalTo(self.rankingPageTabBarView.snp.width).dividedBy(2)
                $0.top.equalTo(self.rankingPageTabBarContainerView.snp.bottom)
                $0.leading.equalTo(self.rankingPageTabBarView).offset(position)
            }
            
            self.view.layoutIfNeeded()
        }
        
        if indexPath.item == 0 {
            // TODO: RankingDrinkPageView 보여주기
        }
        
        if indexPath.item == 1 {
            // TODO: RankingCombinationPageView 보여주기
        }
    }
}

// MARK: - 페이지 탭바 CollectionViewFlowLayout 델리게이트

extension RankingViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width / CGFloat(2)
        let itemHeight = moderateScale(number: 40)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
