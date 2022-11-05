//
//  PopoverbackgroundView.swift
//  PopoverViewInTextView
//
//  Created by Dongyoung Kwon on 2022/11/04.
//

import UIKit

final class PopoverbackgroundView: UIPopoverBackgroundView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
        self.backgroundColor = UIColor.clear
        self.layer.shadowColor = UIColor.clear.cgColor
        self.tintColor = UIColor.brown
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isOpaque = false
        self.backgroundColor = UIColor.clear
        self.layer.shadowColor = UIColor.clear.cgColor
        self.tintColor = UIColor.brown
    }
    
    override static func arrowBase() -> CGFloat { return 0.0 }
    override static func arrowHeight() -> CGFloat { return 0.0 }
    
    override class func contentViewInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private var _arrowOffset: CGFloat = 0.0
    private var _arrowDirection: UIPopoverArrowDirection = UIPopoverArrowDirection(rawValue: 0)
    
    override var arrowOffset: CGFloat {
        get { _arrowOffset }
        set { _arrowOffset = newValue }
    }
    
    override var arrowDirection: UIPopoverArrowDirection {
        get { _arrowDirection }
        set { _arrowDirection = newValue }
    }
    
    override class var wantsDefaultContentAppearance: Bool { return false }    
}
