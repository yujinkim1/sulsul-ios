//
//  DetailFeedViewController.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-10.
//

import Combine
import UIKit
import DesignSystem
import Service

public final class DetailFeedViewController: BaseViewController {
    var feedID: Int
    
    private var detailFeedVM: DetailFeedViewModel
    private var commentVM: CommentViewModel
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
    
    private lazy var detailFeedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
        $0.register(DetailFeedMainCell.self, forCellWithReuseIdentifier: DetailFeedMainCell.reuseIdentifier)
        $0.register(DetailFeedCommentCell.self, forCellWithReuseIdentifier: DetailFeedCommentCell.reuseIdentifier)
        $0.register(DetailFeedRelatedCell.self, forCellWithReuseIdentifier: DetailFeedRelatedCell.reuseIdentifier)
        $0.registerSupplimentaryView(CommentHeaderView.self, supplementaryViewOfKind: .header)
        $0.registerSupplimentaryView(RelatedFeedHeaderView.self, supplementaryViewOfKind: .header)
        $0.registerSupplimentaryView(CommentFooterView.self, supplementaryViewOfKind: .footer)
    }
    
    public init(feedID: Int = 0) {
        self.feedID = feedID
        self.detailFeedVM = DetailFeedViewModel(feedID: feedID)
        self.commentVM = CommentViewModel(feedId: feedID)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.setTabBarHidden(true)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        verifyLoginUser()
        addGestures()
        addViews()
        makeConstraints()
        
        if feedID != 0 {
            bind()
        } else {
            showNotFoundView()
        }
    }
    
    public override func addViews() {
        super.addViews()
        
        baseTopView.addSubviews([
            titleLabel,
            likeTouchableImageView,
            menuTouchableImageView
        ])
        
        view.addSubviews([
            baseTopView,
            detailFeedCollectionView,
            bottomView,
            commentTextFieldView
        ])
        
        view.bringSubviewToFront(commentTextFieldView)
    }
    
    public override func makeConstraints() {
        super.makeConstraints()
        
        baseTopView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 59))
            $0.width.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        likeTouchableImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(menuTouchableImageView.snp.leading).offset(moderateScale(number: -8))
            $0.size.equalTo(moderateScale(number: 24))
        }
        menuTouchableImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(moderateScale(number: -20))
            $0.size.equalTo(moderateScale(number: 24))
        }
        
        if feedID != 0 { // 피드 아이디 조회가 가능한 경우에만 제약조건 설정 수행
            detailFeedCollectionView.snp.makeConstraints {
                $0.top.equalTo(baseTopView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
            bottomView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(moderateScale(number: 76))
                $0.bottom.equalToSuperview()
            }
            commentTextFieldView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 12))
                $0.height.equalTo(moderateScale(number: 48))
                $0.bottom.equalToSuperview().inset(moderateScale(number: 28))
            }
        } else if feedID == 0 { // 피드 아이디 조회를 할 수 없는 경우 빈 화면 생성
            showNotFoundView()
        }
    }
    
    override public func setupIfNeeded() {
        baseTopView.backTouchableView.onTapped { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        likeTouchableImageView.setOpaqueTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            
            if UserDefaultsUtil.shared.isLogin() {
                // 좋아요 저장
                print("로그인 되어 있는 사용자")
            } else if !UserDefaultsUtil.shared.isLogin() {
                print("로그인 되어있지 않은 사용자")
                self.showToastMessageView(toastType: .error, title: "로그인해야 좋아요를 남길 수 있어요.")
            }
        }
        
        menuTouchableImageView.setOpaqueTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            
            // 신고하기 바텀 시트 추가 필요
            let viewController = SpamBottomSheet()
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: false)
        }
        
        commentTextFieldView.touchableLabel.onTapped { [weak self] in
            guard let self = self else { return }
            
            if let text = self.commentTextFieldView.textField.text,
               text.removeSpace() != "" {
                let feedID = self.feedID
                
                self.commentVM.didTabWriteComment(feedID, content: text, parentId: 0)
                self.detailFeedCollectionView.reloadData()
            }
        }
    }
    
    override public func deinitialize() {
        NotificationCenter.default.removeObserver(
            UIResponder.keyboardWillShowNotification
        )
        NotificationCenter.default.removeObserver(
            UIResponder.keyboardWillHideNotification
        )
    }
    
    private func bind() {
        detailFeedVM.requestDetailFeed()

        detailFeedVM
            .detailFeedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.detailFeedCollectionView.reloadData()
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
    
    private func addGestures() {
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleKeyboard))
        
        view.addGestureRecognizer(viewTapGesture)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), 
                                                      heightDimension: .estimated(747-140))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .estimated(747-140))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 0
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                
                return section
            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), 
                                                      heightDimension: .estimated(393))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), 
                                                       heightDimension: .estimated(393))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 0
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .estimated(48))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                         elementKind: UICollectionView.elementKindSectionHeader,
                                                                         alignment: .top)
                
                let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), 
                                                        heightDimension: .estimated(48))
                
                let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, 
                                                                         elementKind: UICollectionView.elementKindSectionFooter,
                                                                         alignment: .bottom)
                
                section.boundarySupplementaryItems = [header, footer]
                
                return section
            case 2:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), 
                                                      heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .fractionalHeight(1))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 0
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .estimated(48))
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
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = view.convert(keyboardFrame, to: nil).size.height
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            
            self.commentTextFieldView.snp.remakeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(moderateScale(number: 50))
            }
            
            self.commentTextFieldView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            
            self.commentTextFieldView.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 12))
                $0.height.equalTo(moderateScale(number: 48))
                $0.bottom.equalToSuperview().inset(moderateScale(number: 28))
            }
            
            self.commentTextFieldView.transform = .identity
            
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - DetailFeed CollectionView Datasource

extension DetailFeedViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        // 메인, 댓글, 연관 피드
        return 3
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch section {
        // 각 섹션마다 생성되는 셀 아이템은 1개씩
        case 0, 1, 2: return 1
        default: return 0
        }
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.section {
        // 해당하는 피드의 상세 내용을 보여주는 DetailFeedMainCell
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailFeedMainCell.reuseIdentifier, for: indexPath) as? DetailFeedMainCell 
            else { return .init() }
            
            detailFeedVM
                .detailFeedPublisher
                .sink { model in cell.bind(model) }
                .store(in: &cancelBag)
            
            detailFeedVM
                .pairingDrinkPublisher
                .sink { value in cell.pairingStackView.drinkLabel.text = value }
                .store(in: &cancelBag)
            
            detailFeedVM
                .pairingSnackPublisher
                .sink { value in cell.pairingStackView.snackLabel.text = value }
                .store(in: &cancelBag)
            
            return cell
        // 해당하는 피드의 댓글을 최대 5개만 보여주는 DetailFeedCommentCell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailFeedCommentCell.reuseIdentifier, for: indexPath) as? DetailFeedCommentCell 
            else { return .init() }
            
            return cell
        // 해당하는 피드와 연관된 피드가 있으면 보여주는 DetailFeedRelatedCell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailFeedRelatedCell.reuseIdentifier, for: indexPath) as? DetailFeedRelatedCell 
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
                guard let headerView = collectionView.dequeueSupplimentaryView(CommentHeaderView.self, 
                                                                               supplementaryViewOfKind: .header, indexPath: indexPath)
                else { return .init() }
                
                headerView.bind(toComment: detailFeedVM.fetchCommentCount())
                
                return headerView
            } else if kind == footer {
                guard let footerView = collectionView.dequeueSupplimentaryView(CommentFooterView.self, 
                                                                               supplementaryViewOfKind: .footer, indexPath: indexPath)
                else { return .init() }
                
                footerView.touchableLabel.onTapped { [weak self] in
                    let commentVC = CommentViewController()
                    self?.navigationController?.pushViewController(commentVC, animated: true)
                }
                
                return footerView
            }
            
            return UICollectionReusableView()
        case 2:
            guard let headerView = collectionView.dequeueSupplimentaryView(RelatedFeedHeaderView.self, 
                                                                           supplementaryViewOfKind: .header, indexPath: indexPath)
            else { return .init() }
            
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: - Comment TextField Delegate

extension DetailFeedViewController: UITextFieldDelegate {
    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        return true
    }
    
    public func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        return false
    }
    
    @objc private func handleKeyboard() {
        view.endEditing(true)
    }
}
