//
//  WriteContentViewModel.swift
//  Feature
//
//  Created by 김유진 on 2/19/24.
//

import Service
import UIKit

final class WriteContentViewModel {
    private let jsonDecoder = JSONDecoder()

    func uploadImages(_ image: UIImage) {
        NetworkWrapper.shared.postUploadImage(stringURL: "/files/upload?directory=images", image: image) { [weak self] result in
            guard let selfRef = self else { return }
            
            switch result {
            case .success(let response):
                if let decodedData = try? selfRef.jsonDecoder.decode(WriteContentModel.self, from: response) {
                } else {
                    print("[/users/id] Fail Decode")
                }
            case .failure(let error):
                print("[/files/upload] Fail : \(error)")
            }
        }
    }
}
