//
//  SelectPhotoViewModel.swift
//  Feature
//
//  Created by 김유진 on 2/8/24.
//

import UIKit
import Combine
import DesignSystem

final class SelectPhotoViewModel {
    
    func shouldUpateData() -> AnyPublisher<Void, Never> {
        return PhotoAuthUtil.shared.shouldUpateData()
    }
    
    func galleryImages() -> [UIImage] {
        return PhotoAuthUtil.shared.galleryImages()
    }
}
