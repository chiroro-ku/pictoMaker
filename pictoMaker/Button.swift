//
//  Button.swift
//  onepMaker
//
//  Created by 小林千浩 on 2023/06/09.
//

import UIKit

@IBDesignable final class Button: UIButton {
    
    var flag: Bool = true
    
    @IBInspectable var cornerRadius: CGFloat{
        get{
            self.layer.cornerRadius
        }
        
        set{
            self.layer.cornerRadius = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    func switchFlag() {
        self.flag = !self.flag
    }
}
