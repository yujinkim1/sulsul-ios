//
//  FeedDetailViewController.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-10.
//

import Combine
import UIKit
import DesignSystem
import Service

public final class FeedDetailViewController: BaseViewController {
    var feedID: Int
    
    private var firstSection = 0
    private var secondSection = 0
    private var thirdSection = 0
    private var feedDetailViewModel: FeedDetailViewModel
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var baseTopView = BaseTopView()
    private lazy var commentTextFieldView = CommentTextFieldView()
    private lazy var bottomView = UIView().then {
        $0.frame = .zero
        $0.backgroundColor = DesignSystemAsset.black.color
        $0.layer.shadowOpacity = 1
        $0.layer.shadowOffset = CGSize(width: 0, height: -18)
        $0.layer.shadowRadius = CGFloat(18)
        $0.layer.shadowColor = DesignSystemAsset.black.color.cgColor
        $0.layer.masksToBounds = false
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.setLineHeight(28, font: Font.bold(size: 18))
        $0.font = Font.bold(size: 18)
        $0.textAlignment = .center
        $0.text = "피드 상세보기"
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var likeTouchableImageView = TouchableImageView(frame: .zero).then {
        $0.image = UIImage(named: "common_heart")
    }
    
    private lazy var menuTouchableImageView = TouchableImageView(frame: .zero).then {
        $0.image = UIImage(named: "dots_vertical")
    }
    
    private lazy var detailCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
        $0.register(FeedDetailMainCell.self, forCellWithReuseIdentifier: FeedDetailMainCell.reuseIdentifier)
        $0.register(FeedDetailCommentCell.self, forCellWithReuseIdentifier: FeedDetailCommentCell.reuseIdentifier)
        $0.register(RelatedFeedCell.self, forCellWithReuseIdentifier: RelatedFeedCell.reuseIdentifier)
        $0.registerSupplimentaryView(CommentHeaderView.self, supplementaryViewOfKind: .header)
        $0.registerSupplimentaryView(RelatedFeedHeaderView.self, supplementaryViewOfKind: .header)
        $0.registerSupplimentaryView(CommentFooterView.self, supplementaryViewOfKind: .footer)
    }
    
    public init(feedID: Int = 0) {
        self.feedID = feedID
        self.feedDetailViewModel = FeedDetailViewModel(feedID: feedID)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.setTabBarHidden(true)
        
        self.verifyLoginUser()
        self.addViews()
        self.makeConstraints()
        
        if feedID != 0 {
            bind()
        } else {
            showNotFoundView()
        }
    }
    
    public override func addViews() {
        super.addViews()
        
        self.baseTopView.addSubviews([
            self.titleLabel,
            self.likeTouchableImageView,
            self.menuTouchableImageView
        ])
        
        self.view.addSubviews([
            self.baseTopView,
            self.detailCollectionView,
            self.bottomView,
            self.commentTextFieldView
        ])
        
        self.view.bringSubviewToFront(self.commentTextFieldView)
    }
    
    public override func makeConstraints() {
        super.makeConstraints()
        
        self.baseTopView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 59))
            $0.width.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        self.titleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        self.likeTouchableImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(self.menuTouchableImageView.snp.leading).offset(moderateScale(number: -8))
            $0.size.equalTo(moderateScale(number: 24))
        }
        self.menuTouchableImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(moderateScale(number: -20))
            $0.size.equalTo(moderateScale(number: 24))
        }
        
        if feedID != 0 { // 피드 아이디 조회가 가능한 경우에만 제약조건 설정 수행
            self.detailCollectionView.snp.makeConstraints {
                $0.top.equalTo(baseTopView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
            self.bottomView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(moderateScale(number: 76))
                $0.bottom.equalToSuperview()
            }
            self.commentTextFieldView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 12))
                $0.height.equalTo(moderateScale(number: 48))
                $0.bottom.equalToSuperview().inset(moderateScale(number: 28))
            }
        } else if feedID == 0 { // 피드 아이디 조회를 할 수 없는 경우 빈 화면 생성
            showNotFoundView()
        }
    }
    
    override public func setupIfNeeded() {
        self.baseTopView.backTouchableView.onTapped { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        self.likeTouchableImageView.setOpaqueTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            
            self.feedDetailViewModel.requestLikeFeed(self.feedID)
            
            feedDetailViewModel
                .isLikedPublisher
                .receive(on: DispatchQueue.main)
                .sink { value in
                    self.updateLikeTouchableImage(with: value)
                }
                .store(in: &cancelBag)
        }
        
        self.menuTouchableImageView.setOpaqueTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            
            let viewController = SpamBottomSheet()
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: false)
        }
        
        // 다음 작업 시 코디네이터로 관리할 수 있는 방법을 찾아 수정해보기
        self.commentTextFieldView.onTapped { [weak self] in
            guard let self = self else { return }

            let viewController = CommentViewController(feedID: self.feedID)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func bind() {
//        self.feedDetailViewModel.requestFeedDetail()

        self.feedDetailViewModel
            .detailFeedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.secondSection = value.commentCount
                self?.detailCollectionView.reloadData()
            }
            .store(in: &cancelBag)
        
        self.feedDetailViewModel
            .isLikedPublisher
            .receive(on: DispatchQueue.main)
            .sink { value in
                self.updateLikeTouchableImage(with: value)
                print(value) // 좋아요 표시 가져올 수 없음 항상 false로 나옴
            }
            .store(in: &cancelBag)
    }
    
    private func showNotFoundView() {
        lazy var notFoundView = NotFoundDetailFeedView()
        
        self.view.addSubview(notFoundView)
        
        notFoundView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(baseTopView.snp.bottom)
        }
    }
    
    private func verifyLoginUser() {
        if !UserDefaultsUtil.shared.isLogin() {
            commentTextFieldView.textField.isEnabled = false
            commentTextFieldView.onTapped {
                self.showAlertView(withType: .oneButton,
                                   title: "알림",
                                   description: "로그인하면 댓글을 남길 수 있어요.",
                                   submitCompletion: nil,
                                   cancelCompletion: nil)
            }
        }
    }
    
    // MARK: - 피드 상세보기 좋아요 버튼 표기
    private func updateLikeTouchableImage(with isLiked: Bool) {
        if UserDefaultsUtil.shared.isLogin(),
           isLiked {
            self.likeTouchableImageView.image = UIImage(named: "heart_filled")
            self.detailCollectionView.reloadData()
        } else {
            self.likeTouchableImageView.image = UIImage(named: "common_heart")
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(747-140))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(747-140))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 0
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                
                return section
            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: itemSize.heightDimension)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 0
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(48))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                         elementKind: UICollectionView.elementKindSectionHeader,
                                                                         alignment: .top)
                
                let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(48))
                let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, 
                                                                         elementKind: UICollectionView.elementKindSectionFooter,
                                                                         alignment: .bottom)
                
                section.boundarySupplementaryItems = [header, footer]
                
                return section
            case 2:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(173), heightDimension: .absolute(220))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 7)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: itemSize.heightDimension)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                section.interGroupSpacing = 0
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(48))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                         elementKind: UICollectionView.elementKindSectionHeader,
                                                                         alignment: .top)
                
                section.boundarySupplementaryItems = [header]
                
                return section
            default:
                return nil
            }
        }
    }
}

// MARK: - UICollectionView Datasource

extension FeedDetailViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        // 피드 내용, 피드 댓글, 연관 피드
        return 3
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 6 // 보여줄 데이터가 없을 경우 0
        default: return 0
        }
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.section {
        // 피드의 상세 콘텐츠를 보여주는 DetailFeedMainCell
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedDetailMainCell.reuseIdentifier, for: indexPath) as? FeedDetailMainCell 
            else { return .init() }
            
            feedDetailViewModel
                .detailFeedPublisher
                .sink { model in cell.bind(model) }
                .store(in: &cancelBag)
            
            feedDetailViewModel
                .pairingDrinkPublisher
                .sink { value in cell.pairingStackView.drinkLabel.text = value }
                .store(in: &cancelBag)
            
            feedDetailViewModel
                .pairingSnackPublisher
                .sink { value in cell.pairingStackView.snackLabel.text = value }
                .store(in: &cancelBag)
            
            return cell
        // 피드의 댓글 중 5개까지만 보여주는 DetailFeedCommentCell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedDetailCommentCell.reuseIdentifier, for: indexPath) as? FeedDetailCommentCell 
            else { return .init() }
            
            cell.bind(withID: self.feedID)
            
            return cell
        // 피드와 연관된 피드가 있으면 보여주는 DetailFeedRelatedCell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RelatedFeedCell.reuseIdentifier, for: indexPath) as? RelatedFeedCell
            else { return .init() }
            
            return cell
        default: 
            return .init()
        }
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header = UICollectionView.SupplementaryViewOfKind.header.description
        let footer = UICollectionView.SupplementaryViewOfKind.footer.description
        
        switch indexPath.section {
        case 1:
            if kind == header {
                guard let headerView = collectionView.dequeueSupplimentaryView(CommentHeaderView.self, supplementaryViewOfKind: .header, indexPath: indexPath)
                else { return .init() }
                
                headerView.bind(toComment: feedDetailViewModel.fetchCommentCount())
                
                return headerView
            } else if kind == footer {
                guard let footerView = collectionView.dequeueSupplimentaryView(CommentFooterView.self, supplementaryViewOfKind: .footer, indexPath: indexPath)
                else { return .init() }
                
                footerView.touchableLabel.onTapped { [weak self] in
                    guard let feedID = self?.feedID else { return }
                    let commentVC = CommentViewController(feedID: feedID)
                    self?.navigationController?.pushViewController(commentVC, animated: true)
                }
                
                return footerView
            }
            
            return .init()
        case 2:
            guard let headerView = collectionView.dequeueSupplimentaryView(RelatedFeedHeaderView.self, supplementaryViewOfKind: .header, indexPath: indexPath)
            else { return .init() }
            
            return headerView
        default:
            return .init()
        }
    }
}

// MARK: - UICollectionView Delegate

extension FeedDetailViewController: UICollectionViewDelegate {
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        
    }
}
