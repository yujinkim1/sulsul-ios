//
//  DrinkDetailViewController.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-18.
//

import UIKit
import DesignSystem

final class DetailDrinkViewController: BaseViewController {
    // MARK: - Custom Property
    private let descriptionOfList = ["종류", "도수", "원산지"]
    private let dummyOfList = ["희석식 소주", "16%", "한국"]
    private let viewControllers: [UIViewController] = []
    
    private lazy var baseTopView = BaseTopView()
    private lazy var subtypeLabel = UILabel()
    private lazy var ABVLabel = UILabel()
    private lazy var madeInLabel = UILabel()
    
    private lazy var rightBarButton = TouchableLabel().then {
        $0.setLineHeight(22)
        $0.font = Font.semiBold(size: 14)
        $0.text = "취향에 추가"
        $0.textColor = DesignSystemAsset.main.color
    }
    
    private lazy var parentTitleLabel = UILabel().then {
        $0.setLineHeight(28)
        $0.font = Font.bold(size: 18)
        $0.text = "이번주 랭킹"
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var drinkImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "circle.fill")
        $0.backgroundColor = DesignSystemAsset.main.color
    }
    
    private lazy var medalImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "circle.fill")
        $0.backgroundColor = DesignSystemAsset.main.color
    }
    
    private lazy var drinkNameLabel = UILabel().then {
        $0.setLineHeight(16)
    }
    
    private lazy var descriptionStackView = UIStackView().then {
        let label = UILabel().then {
            $0.font = Font.semiBold(size: 14)
            $0.setLineHeight(22)
            $0.textColor = DesignSystemAsset.gray500.color
        }
        
        var labelOfList: [UILabel] = []
        
        descriptionOfList.forEach { item in
            label.text = item
            labelOfList.append(label)
        }
        
        $0.axis = .vertical
        $0.spacing = CGFloat(8)
        $0.addArrangedSubviews(labelOfList)
    }
    
    private lazy var pageTabBarContainerView = UIView().then {
        $0.frame = .zero
    }
    
    private lazy var horizontalFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    
    private lazy var pageTabBarView = UICollectionView(frame: .zero, collectionViewLayout: horizontalFlowLayout).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.delegate = self
        $0.dataSource = self
        $0.register(PageTabBarCell.self, forCellWithReuseIdentifier: PageTabBarCell.reuseIdentifier)
    }
    
    public override func viewDidLoad() {
        addViews()
        makeConstraints()
    }
    
    public override func addViews() {
        self.baseTopView.addSubviews([
            parentTitleLabel,
            rightBarButton
        ])
        
        self.pageTabBarContainerView.addSubview(pageTabBarView)
        
        self.view.addSubviews([
            baseTopView,
            drinkImageView,
            drinkNameLabel
        ])
    }
    
    public override func makeConstraints() {
        drinkImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 160))
        }
        drinkNameLabel.snp.makeConstraints {
            $0.leading.equalTo(drinkImageView.snp.trailing)
            $0.top.equalTo(drinkImageView)
            $0.size.equalTo(moderateScale(number: 24))
        }
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let leadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalHeight(1.0)))
            
            let trailingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3)))
            
            let trailingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
            
            if #available(iOS 16.0, *) {
                let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3)), repeatingSubitem: trailingItem, count: 2)
            } else {
                let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3)), subitem: trailingItem, count: 2)
            }
            
            let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalHeight(1.0)), subitems: [leadingItem, trailingGroup])
            
            let section = NSCollectionLayoutSection(group: nestedGroup)
            
            return section
        }
    }
}

// MARK: - PageTabBar CollectionView DataSource
extension DetailDrinkViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageTabBarCell.reuseIdentifier, for: indexPath)
                as? PageTabBarCell else { return UICollectionViewCell() }
        
        if indexPath.item == 0 {
            cell.title = "안주 추천"
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        } else if indexPath.item == 1 {
            cell.title = "포함피드"
        }
        
        return cell
    }
}

// MARK: - PageTabBar CollectionView Delegate

extension DetailDrinkViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedViewController = viewControllers[indexPath.item]
    }
}
