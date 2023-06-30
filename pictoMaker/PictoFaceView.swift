//
//  PictoFaceView.swift
//  pictoMaker
//
//  Created by 小林千浩 on 2023/06/30.
//

import UIKit

class PictoFaceView: PictoBoneView {

    override var cornerRadius: CGFloat{
        get{
            super.cornerRadius
        }
        
        set{
            if !subBones.isEmpty {
                for subBone in subBones {
                    subBone.cornerRadius = newValue
                }
            }
        }
    }
    
    override var anchorPoint: CGPoint{
        get{
            super.anchorPoint
        }
        
        set{
            super.anchorPoint = CGPoint(x: 0.5, y: 1)
        }
    }
    
    override init(point: CGPoint, size: CGSize) {
        super.init(frame: CGRect(origin: point, size: size))
        self.angle = Double.pi/2
        self.layer.cornerRadius = self.bounds.width/2
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
