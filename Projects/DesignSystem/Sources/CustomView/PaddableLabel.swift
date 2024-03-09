//
//  PaddableLabel.swift
//  DesignSystem
//
//  Created by Yujin Kim on 2024-03-03.
//

import UIKit

public final class PaddableLabel: UILabel {
    fileprivate var padding = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += padding.left + padding.right
        contentSize.height += padding.top + padding.bottom
        
        return contentSize
    }
    
    override public func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
}
