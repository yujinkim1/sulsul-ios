//
//  WriteContentViewModel.swift
//  Feature
//
//  Created by 김유진 on 2/19/24.
//

import Service
import UIKit
import Combine

final class WriteContentViewModel {
    private let jsonDecoder = JSONDecoder()
    private var cancelBag = Set<AnyCancellable>()

    private lazy var imageCount = 0
    private lazy var imageServerURLs: [String] = []
    
    private lazy var uploadOneImage = PassthroughSubject<Void, Never>()
    
    // MARK: output
    lazy var completeUpload = PassthroughSubject<Void, Never>()
    
    init() {
        uploadOneImage
            .sink { [weak self] in
                guard let selfRef = self else { return }
                
                if selfRef.imageCount == selfRef.imageServerURLs.count {
                    selfRef.completeUpload.send(())
                }
            }
            .store(in: &cancelBag)
    }

    func uploadImages(_ images: [UIImage]) {
        imageServerURLs = []
        imageCount = images.count
        
        images.forEach { image in
            uploadImage(image)
        }
    }
    
    private func uploadImage(_ image: UIImage) {
        NetworkWrapper.shared.postUploadImage(stringURL: "/files/upload?directory=images", image: image) { [weak self] result in
            guard let selfRef = self else { return }
            
            switch result {
            case .success(let response):
                if let decodedData = try? selfRef.jsonDecoder.decode(WriteContentModel.self, from: response) {
                    selfRef.imageServerURLs.append(decodedData.url)
                    selfRef.uploadOneImage.send(())
                } else {
                    print("[/users/id] Fail Decode")
                }
            case .failure(let error):
                print("[/files/upload] Fail : \(error)")
            }
        }
    }
}
