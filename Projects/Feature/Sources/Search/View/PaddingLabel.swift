//
//  PaddingLabel.swift
//  Feature
//
//  Created by 김유진 on 3/20/24.
//

import UIKit
import DesignSystem

final class PaddingLabel: UIStackView {
    
    private lazy var label = UILabel().then {
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.regular(size: 12)
    }
    
    convenience init(text: String = "", padding: UIEdgeInsets = .init(top: moderateScale(number: 2),
                                                                 left: moderateScale(number: 8),
                                                                 bottom: moderateScale(number: 2),
                                                                 right: moderateScale(number: 8))) {
                
        self.init(frame: .zero)
        
        setText(text)
        self.isLayoutMarginsRelativeArrangement = true
        self.addArrangedSubview(label)
        self.layoutMargins = padding
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text: String) {
        label.text = text
    }
}
