//
//  SelectPhotoViewController.swift
//  Feature
//
//  Created by 김유진 on 2/5/24.
//

import UIKit
import Photos
import Combine
import DesignSystem

public class SelectPhotoViewController: BaseViewController {
    
    private let viewModel = SelectPhotoViewModel()
    
    private let cellSize = (UIScreen.main.bounds.width - 17.01) / 4
    
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "common_leftArrow")?.withTintColor(DesignSystemAsset.gray900.color), for: .normal)
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "새 피드 작성"
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.bold(size: 18)
    }
    
    private lazy var nextButton = UILabel().then {
        $0.text = "다음"
        $0.textColor = DesignSystemAsset.main.color
        $0.font = Font.semiBold(size: 14)
    }
    
    private lazy var selectedImageView = UIImageView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var bottomShadowView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.black.color
    }
    
    private lazy var flowLayout = UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 5.67
        $0.minimumInteritemSpacing = 5.67
    }
    
    private lazy var imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .white
        $0.delegate = self
        $0.dataSource = self
        $0.register(WriteFeedPhotoCell.self, forCellWithReuseIdentifier: WriteFeedPhotoCell.id)
        $0.backgroundColor = DesignSystemAsset.black.color
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        viewModel
            .fetchImages
            .send(())
        
        viewModel
            .updateData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.imageCollectionView.reloadData()
            }
            .store(in: &cancelBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        makeConstraints()
    }
    
    public override func addViews() {
        view.addSubviews([
            backButton,
            titleLabel,
            nextButton,
            selectedImageView,
            imageCollectionView,
            bottomShadowView
        ])
    }
    
    public override func makeConstraints() {
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(moderateScale(number: 73))
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
            $0.size.equalTo(moderateScale(number: 24))
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.trailing.equalToSuperview().inset(moderateScale(number: 20))
        }
        
        selectedImageView.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 393))
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 12))
            $0.centerX.equalToSuperview()
        }
        
        imageCollectionView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.top.equalTo(selectedImageView.snp.bottom).offset(moderateScale(number: 16))
        }
        
        bottomShadowView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 74))
        }
    }
}

extension SelectPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.galleryImages().count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WriteFeedPhotoCell.id,
                                                            for: indexPath) as? WriteFeedPhotoCell else { return UICollectionViewCell() }
        
        // MARK: 이미지 표시
        let image = viewModel.galleryImages()[indexPath.item]
        cell.bind(image)
        
        // MARK: 선택 상태 표시
        let selection = viewModel.selectStatus(indexPath)
        cell.updateUIBySelection(selection.0, count: selection.1)
                
        cell.photoImageView.onTapped { [weak self] in
            guard let selfRef = self else { return }
            
            if selfRef.viewModel.canSelectImage(indexPath) {
                selfRef.viewModel.toggleSelection(indexPath)
                
                // MARK: 선택 상태 표시
                let selection = selfRef.viewModel.selectStatus(indexPath)
                cell.updateUIBySelection(selection.0, count: selection.1)
                
                // MARK: 커다란 이미지 표시
                selfRef.selectedImageView.image = selfRef.viewModel.lastSelectedImage()
            }
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }
}
