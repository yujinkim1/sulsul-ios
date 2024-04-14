//
//  WriteTitleViewController.swift
//  Feature
//
//  Created by 김유진 on 2/15/24.
//

import UIKit
import DesignSystem
import Service
import Photos
import BSImagePicker

final class WriteTitleViewController: BaseHeaderViewController, CommonBaseCoordinated {
    var coordinator: CommonBaseCoordinator?
    
    private var imagePickerController: ImagePickerProtocol?
    
    private lazy var images: [UIImage] = []
    private lazy var heightByLine: [Int: CGFloat] = [1: 36, 2: 72, 3: 108]
    private lazy var textViewTwoLineHeight: Int? = nil
    private lazy var thumnailIndex = 0
    
    private lazy var thumnailImageView = UIImageView().then {
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .gray
        $0.clipsToBounds = true
    }
    
    private lazy var titlePlaceholderLabel = UILabel().then {
        $0.text = "여기에 제목을 입력해주세요."
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.bold(size: 24)
    }
    
    private lazy var titleTextView = UITextView().then {
        $0.font = Font.bold(size: 24)
        $0.textColor = DesignSystemAsset.gray900.color
        $0.backgroundColor = .clear
        $0.delegate = self
        $0.textContainer.maximumNumberOfLines = 3
    }
    
    private lazy var imageScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
    }
    
    private lazy var imageStackView = UIStackView().then {
        $0.distribution = .equalSpacing
        $0.spacing = moderateScale(number: 8)
        $0.layoutMargins = UIEdgeInsets(top: 0, left: moderateScale(number: 20), bottom: 0, right: moderateScale(number: 20))
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private lazy var reSelectPhotoLabel = UILabel().then {
        $0.text = "사진을 다시 선택하고 싶어요."
        $0.textColor = DesignSystemAsset.gray400.color
        $0.font = Font.bold(size: 16)
    }
    
    private lazy var bottomGradientLayer = CAGradientLayer()
    
    private lazy var bottomGradientView = UIView().then {
        bottomGradientLayer.colors = [UIColor.clear.cgColor,
                                      DesignSystemAsset.black.color.withAlphaComponent(0.1),
                                      DesignSystemAsset.black.color.cgColor]
        bottomGradientLayer.opacity = 1
        bottomGradientLayer.locations = [0, 0.2]
        $0.layer.addSublayer(bottomGradientLayer)
        bottomGradientLayer.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: Int(moderateScale(number: 270)))
        $0.isHidden = true
    }
    
    private lazy var addImageView = UIImage()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let text = UserDefaultsUtil.shared.getFeedTitle() {
            titleTextView.text = text
        }
    }
    
    override func viewDidLayoutSubviews() {
        setTextViewUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let text = titleTextView.text {
            UserDefaultsUtil.shared.setFeedTitle(text)
            titlePlaceholderLabel.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController = ImagePicker(presentationController: self,
                                            delegate: self,
                                            width: nil,
                                            maxSelectionChangeable: true)
        
        setHeaderText("썸네일&제목입력", actionText: "다음")
        
        reSelectPhotoLabel.onTapped { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        actionButton.onTapped { [weak self] in
            guard let selfRef = self else { return }
            
            if !(selfRef.titleTextView.text.replacingOccurrences(of: " ", with: "").isEmpty) {
                var thumnailFirstSort = selfRef.images
                let thumnail = thumnailFirstSort.remove(at: selfRef.thumnailIndex)
                thumnailFirstSort.insert(thumnail, at: 0)
                
                selfRef.coordinator?.moveTo(appFlow: AppFlow.tabBar(.common(.writeContent)), userData: ["images": thumnailFirstSort])
                
            } else {
                selfRef.showToastMessageView(toastType: .error, title: "제목을 입력해주세요")
            }
        }
        
        thumnailImageView.onTapped { [weak self] in
            self?.checkPermission()
        }
    }
    
    func setSelectedImages(_ images: [UIImage]) {
        self.images = images
        
        images.enumerated().forEach { index, image in
            let imageView = SelectableImageView(image: image)
            
            if index == 0 {
                imageView.isSelected = true
                thumnailImageView.image = image
            }
            
            imageView.updateSelection()

            imageView.snp.makeConstraints {
                $0.size.equalTo(moderateScale(number: 72))
            }
            
            imageView.onTapped { [weak self] in
                self?.imageScrollView.scrollRectToVisible(imageView.frame,
                                                          animated: true)
                self?.thumnailIndex = index
                self?.thumnailImageView.image = image
                self?.updateThumnailImage(index)
            }
            
            imageStackView.addArrangedSubview(imageView)
        }
    }
    
    private func updateThumnailImage(_ selectedIndex: Int) {
        imageStackView.arrangedSubviews.enumerated().forEach { index, imageView in
            guard let imageView = imageView as? SelectableImageView else { return }
            
            imageView.isSelected = (index == selectedIndex)
            imageView.updateSelection()
        }
    }
    
    override func addViews() {
        super.addViews()
        
        view.addSubviews([
            thumnailImageView,
            imageScrollView,
            reSelectPhotoLabel,
            titlePlaceholderLabel,
            titleTextView
        ])
        
        thumnailImageView.addSubview(bottomGradientView)
        
        imageScrollView.addSubview(imageStackView)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        thumnailImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(headerView.snp.bottom)
            $0.size.equalTo(moderateScale(number: 353))
        }
        
        bottomGradientView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(thumnailImageView).dividedBy(1.5)
        }
        
        titlePlaceholderLabel.snp.makeConstraints {
            $0.trailing.equalTo(thumnailImageView).inset(moderateScale(number: 16))
            $0.bottom.equalTo(thumnailImageView).inset(moderateScale(number: 16))
            $0.leading.equalTo(thumnailImageView).inset(moderateScale(number: 22))
            $0.height.equalTo(moderateScale(number: 36))
        }
        
        titleTextView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(thumnailImageView).inset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 36))
        }
        
        imageScrollView.snp.makeConstraints {
            $0.top.equalTo(thumnailImageView.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 72))
        }
        
        reSelectPhotoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(moderateScale(number: 56))
        }
        
        imageStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setTextViewUI() {
        let numberOfLine = Int(titleTextView.contentSize.height / titleTextView.font!.lineHeight)
        guard let height = heightByLine[numberOfLine] else { return }
        
        titleTextView.snp.remakeConstraints {
            $0.leading.trailing.bottom.equalTo(thumnailImageView).inset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: height))
        }
        
        titlePlaceholderLabel.isHidden = !titleTextView.text.isEmpty
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
}

extension WriteTitleViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 30
    }
    
    func textViewDidChange(_ textView: UITextView) {
        setTextViewUI()
    }
}

extension WriteTitleViewController: ImagePickerDelegate {
    func didSelect(assets: [PHAsset]?,
                   deletedAssets: [PHAsset]?) {
        
        print("|| 1. \(assets?.count)")
        print("|| 2. \(deletedAssets?.count)")
    }
}

extension WriteTitleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func checkPermission() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            switch status {
            case .limited:
                PHPhotoLibrary.shared().register(self)
                let actionSheet = UIAlertController(title: "",
                                                    message: "더 많은 사진을 선택하거나 모든 사진에 대한 액세스를 허용하려면 설정으로 이동해주세요.",
                                                    preferredStyle: .actionSheet)
                
                let selectPhotosAction = UIAlertAction(title: "더 많은 사진 선택",
                                                       style: .default) { [weak self] _ in
                    guard let self = self else { return }
                    if #available(iOS 15, *) {
                        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self) { [weak self] _ in
                            self?.imagePickerController?.present(max: 5)
                        }
                    } else {
                        imagePickerController?.present(max: 5)
                    }
                }
                actionSheet.addAction(selectPhotosAction)
                
                let allowFullAccessAction = UIAlertAction(title: "권한 설정으로 이동",
                                                          style: .default) { _ in
                    guard let settingsURL = URL(string: UIApplication.openSettingsURLString),
                            UIApplication.shared.canOpenURL(settingsURL) else { return }
                    UIApplication.shared.open(settingsURL, completionHandler: nil)
                }
                actionSheet.addAction(allowFullAccessAction)
                
                let cancelAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] _ in
                    self?.imagePickerController?.present(max: 5)
                }
                actionSheet.addAction(cancelAction)
                
                present(actionSheet, animated: true, completion: nil)
                
            case .authorized:
                imagePickerController?.present(max: 5)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization() { [weak self] newStatus in
                    guard let selfRef = self else { return }
                    if newStatus == PHAuthorizationStatus.authorized {
                        selfRef.imagePickerController?.present(max: 5)
                    }
                }
            default:
                showAlertView(withType: .twoButton,
                              title: "알림",
                              description: "사진을 불러올 수 없습니다. \n사진 접근 권한을 허용해주세요.",
                              submitCompletion: {
                    guard let settingsURL = URL(string: UIApplication.openSettingsURLString),
                          UIApplication.shared.canOpenURL(settingsURL) else { return }
                    UIApplication.shared.open(settingsURL, completionHandler: nil)
                }, cancelCompletion: nil)
            }
    }
}


extension WriteTitleViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        LogDebug(changeInstance)
    }
}
