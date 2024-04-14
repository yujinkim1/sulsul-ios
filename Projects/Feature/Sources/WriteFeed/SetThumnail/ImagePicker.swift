//
//  ImagePicker.swift
//  Feature
//
//  Created by 김유진 on 4/14/24.
//
//  Copyright © 2022 Joakim Gyllström. All rights reserved.

import UIKit
import Photos
import BSImagePicker

public protocol ImagePickerDelegate: AnyObject {
    func didSelect(assets: [PHAsset]?, deletedAssets: [PHAsset]?)
}

public protocol ImagePickerProtocol {
    func present()
    func present(max: Int)
    func didAssetOrderChanged(asset: PHAsset?)
    func evenAssetsCount() -> Int
}

open class ImagePicker: ImagePickerProtocol {
    private let imageManager = PHImageManager.default()
    
    private var evenAssets = [PHAsset]()
    private var addedAssets = [PHAsset]()
    private var deletedAssets = [PHAsset]()
    
    private var imagePicker = ImagePickerController()
    private weak var delegate: ImagePickerDelegate?
    private var presentationController: UIViewController?
    private var width: CGFloat?
    private var max = 10
    private var maxSelectionChangeable = false
    
    private lazy var cancelLabel = UILabel().then({
        $0.text = "취소"
        $0.textColor = .systemBlue
    })
    
    public init(presentationController: UIViewController,
                delegate: ImagePickerDelegate,
                width: CGFloat?,
                max: Int? = nil,
                maxSelectionChangeable: Bool? = false) {
        
        self.presentationController = presentationController
        self.delegate = delegate
        self.width = width
        if let max = max {
            self.max = max
        }
        if let maxSelectionChangeable = maxSelectionChangeable {
            self.maxSelectionChangeable = maxSelectionChangeable
        }
    }
    
    public func present() {
    }
    
    public func didAssetOrderChanged(asset: PHAsset?) {
        self.evenAssets.removeAll(where: { $0 == asset! })
        self.imagePicker.deselect(asset: asset!)
    }
    
    public func present(max: Int) {

        
        print("||G")
    }
    
    public func evenAssetsCount() -> Int {
        evenAssets.count
    }
}
