//
//  UIImageView+Extension.swift
//  DesignSystem
//
//  Created by 김유진 on 2023/12/12.
//

import UIKit

public extension UIImageView {
    func loadImage(_ url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
