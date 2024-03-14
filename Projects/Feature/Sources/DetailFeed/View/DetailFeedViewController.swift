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
    var viewModel: DetailFeedViewModel
    
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var baseTopView = BaseTopView().then {
        $0.frame = .zero
    }
    
    private lazy var sendTouchableLabel = TouchableLabel().then {
        $0.frame = CGRect(x: 0, y: 0, width: 12, height: 0)
        $0.setLineHeight(24)
        $0.font = Font.semiBold(size: 16)
        $0.text = "등록"
        $0.textColor = DesignSystemAsset.gray500.color
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.setLineHeight(28)
        $0.font = Font.bold(size: 18)
        $0.textAlignment = .center
        $0.text = "피드 상세"
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var likeTouchableImageView = TouchableImageView(frame: .zero).then {
        $0.image = UIImage(named: "common_heart")
    }
    
    private lazy var pullDownTouchableImageView = TouchableImageView(frame: .zero).then {
        $0.image = UIImage(named: "dots_vertical")
    }
    
    private lazy var detailFeedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createFlowLayout()).then {
        $0.register(DetailFeedMainCell.self, forCellWithReuseIdentifier: DetailFeedMainCell.reuseIdentifier)
        $0.register(DetailFeedCommentCell.self, forCellWithReuseIdentifier: DetailFeedCommentCell.reuseIdentifier)
        $0.register(DetailFeedRelatedCell.self, forCellWithReuseIdentifier: DetailFeedRelatedCell.reuseIdentifier)
        $0.register(
            CommentHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CommentHeaderView.reuseIdentifier
        )
        $0.register(
            RelatedFeedHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: RelatedFeedHeaderView.reuseIdentifier
        )
        $0.backgroundColor = .red // FIXME: 디버그 용으로 나중에 clear로 변경
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
    }
    
    private lazy var commentTextField = PaddableTextField(to: 12).then {
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.autocapitalizationType = .none
        $0.rightView = sendTouchableLabel
        $0.rightViewMode = .always
        $0.placeholder = "댓글을 입력해볼까요?"
        $0.layer.cornerRadius = CGFloat(8)
        $0.layer.borderWidth = CGFloat(1)
        $0.layer.borderColor = DesignSystemAsset.gray300.color.cgColor
        $0.layer.masksToBounds = true
        $0.backgroundColor = DesignSystemAsset.black.color
        $0.delegate = self
    }
    
    public init(viewModel: DetailFeedViewModel) {
        self.viewModel = viewModel
        
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
        
        addGestures()
        bind()
    }
    
    public override func addViews() {
        baseTopView.addSubviews([
            titleLabel,
            likeTouchableImageView,
            pullDownTouchableImageView
        ])
        
        view.addSubviews([
            baseTopView,
            detailFeedCollectionView,
            commentTextField
        ])
    }
    
    public override func makeConstraints() {
        baseTopView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 59))
            $0.width.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(baseTopView.backTouchableView.snp.trailing)
            $0.trailing.equalTo(likeTouchableImageView.snp.leading)
            $0.centerY.equalToSuperview()
        }
        likeTouchableImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(pullDownTouchableImageView.snp.leading).offset(moderateScale(number: -8))
            $0.size.equalTo(moderateScale(number: 24))
        }
        pullDownTouchableImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(moderateScale(number: -20))
            $0.size.equalTo(moderateScale(number: 24))
        }
        detailFeedCollectionView.snp.makeConstraints {
            $0.top.equalTo(baseTopView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.bottom.equalTo(commentTextField.snp.top)
        }
        commentTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 12))
            $0.height.equalTo(moderateScale(number: 48))
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override public func setupIfNeeded() {
        likeTouchableImageView.setOpaqueTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            
            if UserDefaultsUtil.shared.getInstallationId() != 0 {
                print("로그인 되어 있는 사용자")
            } else {
                print("로그인 되어있지 않은 사용자")
                self.showAlertView(withType: .oneButton, title: "로그인이 필요해요", description: "로그인 후 해당 피드에 좋아요를 남길 수 있어요.") {
                        
                    } cancelCompletion: {
                        
                    }
            }
        }
        
        sendTouchableLabel.setOpaqueTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            
            print("등록 버튼 눌림")
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
    
    // MARK: - Custom Method
    
    private func bind() {
        print("DetailFeedViewController - bind() called")
            viewModel.requestDetailFeed()

            viewModel
                .detailFeedPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    print("DetailFeedViewController - received detail feed: \(value)")
                    let title = value.title
                    print(title)
                    self?.detailFeedCollectionView.reloadData()
                }
                .store(in: &cancelBag)
//        viewModel.requestDetailFeed()
//        viewModel.requestParingDrink(1)
//        
//        viewModel
//            .detailFeedPublisher
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] value in
//                self?.detailFeedCollectionView.reloadData()
//            }
//            .store(in: &cancelBag)
//        
//        viewModel
//            .pairingDrinkPublisher
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] value in
//                self?.titleLabel.text = value
//            }
//            .store(in: &cancelBag)
    }
    
    private func addGestures() {
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleKeyboard))
        
        view.addGestureRecognizer(viewTapGesture)
    }
    
    private func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout().then {
            $0.scrollDirection = .vertical // 방향을 horizontal로 변경
            $0.itemSize = CGSize(width: view.frame.width - 40, height: moderateScale(number: 353)) // 셀 사이즈 설정
            $0.minimumLineSpacing = 0 // 셀 사이 간격을 0으로 설정
            $0.minimumInteritemSpacing = 0 // 아이템 간 간격을 0으로 설정
        }
        
        return layout
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = view.convert(keyboardFrame, to: nil).size.height
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            
            self.commentTextField.snp.remakeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(moderateScale(number: 50))
            }
            
            self.commentTextField.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            
            self.commentTextField.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 12))
                $0.height.equalTo(moderateScale(number: 48))
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
            
            self.commentTextField.transform = .identity
            
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - DetailFeed CollectionView Datasource

extension DetailFeedViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3 // 섹션은 메인, 댓글, 연관 피드로 총 3개다.
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch section {
        case 0: return 1
        case 1: return 5
        case 2: return 6
        default: return 0
        }
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        // 첫 번째 섹션은 DFMainCell이어야 한다.
        // 두 번째 섹션은 DFCommentCell이어야 한다.
        // 세 번째 섹션은 DFRelatedFeedCell이어야 한다.
        
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailFeedMainCell.reuseIdentifier, for: indexPath) as? DetailFeedMainCell else { return UICollectionViewCell() }
            
//            let item = viewModel.feedDatasource?[indexPath.item]
            
            viewModel
                .detailFeedPublisher
                .receive(on: DispatchQueue.main)
                .sink { value in
                    cell.bind(value)
                }
                .store(in: &cancelBag)
            
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailFeedCommentCell.reuseIdentifier, for: indexPath) as? DetailFeedCommentCell else { return UICollectionViewCell() }
            
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailFeedRelatedCell.reuseIdentifier, for: indexPath) as? DetailFeedRelatedCell else { return UICollectionViewCell() }
            
            return cell
        default: return UICollectionViewCell()
        }
    }
    
//    public func collectionView(
//        _ collectionView: UICollectionView,
//        viewForSupplementaryElementOfKind kind: String,
//        at indexPath: IndexPath
//    ) -> UICollectionReusableView {
//        guard kind == UICollectionView.elementKindSectionHeader,
//              let header = collectionView.dequeueReusableSupplementaryView(
//                ofKind: <#T##String#>,
//                withReuseIdentifier: <#T##String#>,
//                for: indexPath
//              )
//    }
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
