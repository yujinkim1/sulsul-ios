//
//  DetailFeedMainCell.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-14.
//

import UIKit
import DesignSystem

final class DetailFeedMainCell: UICollectionViewCell {
    static let reuseIdentifier: String = "DetailFeedMainCell"
    var drinkName: String = ""
    private var imageOfList: [String] = [
        "https://s3-ap-northeast-2.amazonaws.com/sulsul-s3/images%2Fb2c56315-9726-4bc4-a7d7-f7d20e303fc1.jpg",
        "https://s3-ap-northeast-2.amazonaws.com/sulsul-s3/images%2Fb2c56315-9726-4bc4-a7d7-f7d20e303fc1.jpg"
    ]
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .clear
        $0.frame = .zero
    }
    
    private lazy var flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = CGSize(width: 353, height: 353)
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
    }
    
    private lazy var carouselCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.reuseIdentifier)
        $0.dataSource = self
    }
    
    private lazy var indexLabel = PaddableLabel(edgeInsets: 2, 8, 2, 8).then {
        $0.setLineHeight(18)
        $0.font = Font.regular(size: 12)
        $0.text = "0/5" // 현재 셀의 인덱스 / Carousel 셀의 개수
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.setLineHeight(36)
        $0.font = Font.bold(size: 24)
        $0.textColor = DesignSystemAsset.white.color
        $0.numberOfLines = 2
    }
    
    private lazy var indicatorView = UIView().then {
        $0.frame = .zero
        $0.backgroundColor = DesignSystemAsset.main.color
    }
    
    private lazy var profileImageView = UIImageView().then {
        $0.backgroundColor = .white
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = CGFloat(20)
        $0.layer.masksToBounds = true
    }
    
    private lazy var usernameLabel = UILabel().then {
        $0.setLineHeight(28)
        $0.font = Font.bold(size: 18)
        $0.text = "알 수 없음"
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var createAtLabel = UILabel().then {
        $0.setLineHeight(16)
        $0.font = Font.regular(size: 10)
        $0.text = "24.03.14"
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var scoreLabel = UILabel().then {
        $0.setLineHeight(28)
        $0.font = Font.bold(size: 18)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var scoreLevelImageView = UIImageView().then {
        $0.image = UIImage(named: "score_level_0")
    }
    
    private lazy var drinkLabel = PaddableLabel(edgeInsets: 1, 4, 1, 4).then {
        $0.setLineHeight(18)
        $0.font = Font.semiBold(size: 12)
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.textColor = DesignSystemAsset.gray400.color
    }
    
    private lazy var snackLabel = PaddableLabel(edgeInsets: 1, 4, 1, 4).then {
        $0.setLineHeight(18)
        $0.font = Font.semiBold(size: 12)
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.textColor = DesignSystemAsset.gray400.color
    }
    
    private lazy var textView = UITextView().then {
        $0.font = Font.medium(size: 16)
        $0.textColor = DesignSystemAsset.gray800.color
    }
    
    private lazy var feedViewsImageView = UIImageView().then {
        $0.image = UIImage(named: "views")
    }
    
    private lazy var feedCommentsImageView = UIImageView().then {
        $0.image = UIImage(named: "comments")
    }
    
    private lazy var feedLikesImageView = UIImageView().then {
        $0.image = UIImage(named: "likes")
    }
    
    private lazy var feedViewsLabel = UILabel().then {
        $0.setLineHeight(22)
        $0.font = Font.medium(size: 14)
        $0.text = "0"
        $0.textColor = DesignSystemAsset.gray400.color
    }
    
    private lazy var feedCommentsLabel = UILabel().then {
        $0.setLineHeight(22)
        $0.font = Font.medium(size: 14)
        $0.text = "0"
        $0.textColor = DesignSystemAsset.gray400.color
    }
    
    private lazy var feedLikesLabel = UILabel().then {
        $0.setLineHeight(22)
        $0.font = Font.medium(size: 14)
        $0.text = "0"
        $0.textColor = DesignSystemAsset.gray400.color
    }
    
    private lazy var feedViewsStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = CGFloat(6)
        $0.distribution = .fillEqually
        $0.addArrangedSubviews([feedViewsImageView, feedViewsLabel])
    }
    
    private lazy var feedCommentsStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = CGFloat(6)
        $0.distribution = .fillEqually
        $0.addArrangedSubviews([feedCommentsImageView, feedCommentsLabel])
    }
    
    private lazy var feedLikesStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = CGFloat(6)
        $0.distribution = .fillEqually
        $0.addArrangedSubviews([feedLikesImageView, feedLikesLabel])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .black
        
        addViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func addViews() {
        containerView.addSubviews([
            carouselCollectionView,
            indicatorView,
            profileImageView,
            usernameLabel,
            createAtLabel,
            textView,
            feedViewsStackView,
            feedCommentsStackView,
            feedLikesStackView
        ])
        
        contentView.addSubviews([
            indexLabel,
            titleLabel
        ])
        
        addSubview(containerView)
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        carouselCollectionView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }
        indexLabel.snp.makeConstraints {
            $0.leading.equalTo(carouselCollectionView.snp.leading).inset(moderateScale(number: 18))
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(indexLabel)
            $0.top.equalTo(indexLabel.snp.bottom).offset(moderateScale(number: 4))
        }
        indicatorView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(carouselCollectionView.snp.bottom).offset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 2))
        }
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(indicatorView.snp.bottom).offset(moderateScale(number: 26))
            $0.size.equalTo(moderateScale(number: 40))
        }
        usernameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(moderateScale(number: 12))
            $0.top.equalTo(indicatorView.snp.bottom).offset(moderateScale(number: 24))
        }
        createAtLabel.snp.makeConstraints {
            $0.leading.equalTo(usernameLabel)
            $0.top.equalTo(usernameLabel.snp.bottom).offset(moderateScale(number: 8))
        }
        textView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(createAtLabel.snp.bottom).offset(moderateScale(number: 16))
        }
        feedViewsStackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalTo(containerView.snp.bottom).inset(moderateScale(number: 22))
        }
        feedCommentsStackView.snp.makeConstraints {
            $0.leading.equalTo(feedViewsStackView.snp.trailing).offset(moderateScale(number: 16))
            $0.bottom.equalTo(feedViewsStackView)
        }
        feedLikesStackView.snp.makeConstraints {
            $0.leading.equalTo(feedCommentsStackView.snp.trailing).offset(moderateScale(number: 16))
            $0.bottom.equalTo(feedViewsStackView)
        }
    }
    
    func bind(_ model: Feed) {
        // 셀에 필요한 데이터 주입
        print(drinkName)
        imageOfList = model.images
        carouselCollectionView.reloadData()
        
        // updateScoreImageView(to: model.score)
        
//        if let profileImage = model.writerInfo.image,
//           let profileImageURL = URL(string: profileImage) {
//            profileImageView.loadImage(profileImageURL)
//        } else {
//            print("Image URL is not available.")
//            profileImageView.image = UIImage()
//        }
        
        usernameLabel.text = drinkName
        
        // createAtLabel.text = model.createdAt
        
        textView.text = model.content
        
        // feedViewsLabel.text = String(model.viewCount)
        
        // feedCommentsLabel.text = String(model.commentsCount)
        
        // feedLikesLabel.text = String(model.likesCount)
        
        // scoreLabel.text = String("\(model.score)점")
    }
    
    private func updateScoreImageView(to score: Int) {
        switch score {
        case 5: scoreLevelImageView.image = UIImage(named: "score_level_5")
        case 4: scoreLevelImageView.image = UIImage(named: "score_level_4")
        case 3: scoreLevelImageView.image = UIImage(named: "score_level_3")
        case 2: scoreLevelImageView.image = UIImage(named: "score_level_2")
        case 1: scoreLevelImageView.image = UIImage(named: "score_level_1")
        default: scoreLevelImageView.image = UIImage(named: "score_level_0")
        }
    }
}

extension DetailFeedMainCell: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return imageOfList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.reuseIdentifier, for: indexPath) as? CarouselCell else { return UICollectionViewCell() }
        
        let item = imageOfList[indexPath.item]
        
        cell.configure(item)
        
        return cell
    }
}
