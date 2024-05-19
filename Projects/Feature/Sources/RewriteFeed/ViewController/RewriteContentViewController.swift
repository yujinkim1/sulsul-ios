//
//  RewriteContentViewController.swift
//  Feature
//
//  Created by Yujin Kim on 2024-05-19.
//

import UIKit
import Combine
import DesignSystem
import Photos

final class RewriteContentViewController: BaseHeaderViewController {
    // MARK: - Properties
    //
    private var feedID: Int
    private var originTitle: String
    private var originContent: String
    private var originRepresentImage: String
    private var originImages: [String]
    private var originUserTags: [String]
    
    private var cancelBag = Set<AnyCancellable>()
    private var imagePickerController: ImagePickerProtocol?

    // MARK: - UI Components
    //
    private lazy var representImageView = UIImageView().then {
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .darkGray
        $0.clipsToBounds = true
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
    
    private let contentTextView = UITextView().then {
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 8.0
    }
    
    private lazy var imagesTextField = UITextField().then {
        $0.placeholder = "Image URLs (comma separated)"
        $0.borderStyle = .roundedRect
    }
    
    private lazy var userTagsTextField = UITextField().then {
        $0.placeholder = "User Tags (comma separated)"
        $0.borderStyle = .roundedRect
    }
    
    private lazy var saveButton = UIButton(type: .system).then {
        $0.setTitle("수정", for: .normal)
        $0.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }

    // MARK: - Initializer
    //
    init(
        feedID: Int,
        title: String,
        content: String,
        representImage: String,
        images: [String],
        userTags: [String]
    ) {
        self.feedID = feedID
        self.originTitle = title
        self.originContent = content
        self.originRepresentImage = representImage
        self.originImages = images
        self.originUserTags = userTags
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setHeaderText("피드 수정", actionText: "완료")
        
        self.bind()
        print("originImages: \(originImages)")
    }
    
    // MARK: - Setup UI
    //
    override func addViews() {
        // TODO:
        // 1. representImageView & titleTextView
        // 2.
        super.addViews()
        
        self.view.addSubviews([
            representImageView,
            titleTextView
        ])
        
        self.view.addSubview(contentTextView)
        self.view.addSubview(imageScrollView)
        self.view.addSubview(userTagsTextField)
        self.view.addSubview(saveButton)
        
        imageScrollView.addSubview(imageStackView)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        self.representImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 353))
        }
        
        self.titleTextView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(self.representImageView).inset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 36))
        }
        
        imageScrollView.snp.makeConstraints {
            $0.top.equalTo(self.representImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 98))
        }
        
        imageStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(self.imageScrollView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(200)
        }
        
        userTagsTextField.snp.makeConstraints {
            $0.top.equalTo(imageScrollView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        saveButton.snp.makeConstraints {
            $0.top.equalTo(userTagsTextField.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - Bind Data
    //
    private func bind() {
        guard let representImageURLString = URL(string: self.originRepresentImage)
        else {
            print("Invalid URL: \(self.originRepresentImage)")
            return
        }
        self.representImageView.kf.setImage(with: representImageURLString)
        
        self.titleTextView.text = originTitle
        
        contentTextView.text = originContent
        userTagsTextField.text = originUserTags.joined(separator: ", ")
                
        originImages.forEach { imageUrl in
            guard let url = URL(string: imageUrl) else {
                print("Invalid URL: \(imageUrl)")
                return
            }
            
            let imageView = DeletableImageView()
            imageView.imageView.kf.setImage(with: url)
            imageView.snp.makeConstraints {
                $0.size.equalTo(moderateScale(number: 98))
            }
            imageStackView.addArrangedSubview(imageView)
        }
    }
    
    // MARK: - Actions
    //
    @objc private func saveButtonTapped() {
        guard let title = titleTextView.text, !title.isEmpty,
              let content = contentTextView.text, !content.isEmpty,
              let imagesText = imagesTextField.text, !imagesText.isEmpty,
              let userTagsText = userTagsTextField.text else {
            return
        }
        
        let images = imagesText.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) }
        let userTags = userTagsText.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) }
        
        let parameters: [String: Any] = [
            "title": title,
            "content": content,
            "images": images,
            "user_tags": userTags
        ]
        
        updateFeed(feedID: feedID, parameters: parameters)
    }
    
    // MARK: - API Request
    //
    private func updateFeed(feedID: Int, parameters: [String: Any]) {
        guard let url = URL(string: "https://api.example.com/feeds/\(feedID)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        URLSession.shared.dataTaskPublisher(for: request)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Feed updated successfully")
                case .failure(let error):
                    print("Failed to update feed: \(error.localizedDescription)")
                }
            }, receiveValue: { _ in
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            })
            .store(in: &cancelBag)
    }
}

extension RewriteContentViewController: UITextViewDelegate {}

extension RewriteContentViewController: ImagePickerDelegate {
    func didSelect(assets: [PHAsset]?, deletedAssets: [PHAsset]?) {}
}
