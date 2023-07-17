//
//  PictoBoneView.swift
//  pictoMaker
//
//  Created by 小林千浩 on 2023/06/27.
//

import UIKit

class PictoBoneView: UIView {
    
    var subBones: [PictoBoneView]! = []
    var angle: CGFloat = -Double.pi/2
    
    var cornerRadius: CGFloat {
        get{
            self.layer.cornerRadius
        }
        
        set{
            self.layer.cornerRadius = newValue
            if !subBones.isEmpty {
                for subBone in subBones {
                    subBone.cornerRadius = newValue
                }
            }
        }
    }
    
    var borderWidth: CGFloat {
        get{
            self.layer.borderWidth
        }
        
        set{
            self.layer.borderWidth = newValue
            if !subBones.isEmpty {
                for subBone in subBones {
                    subBone.borderWidth = newValue
                }
            }
        }
    }
    
    var boneAlpha: CGFloat {
        get{
            self.alpha
        }
        
        set{
            self.alpha = newValue
            if !subBones.isEmpty {
                for subBone in subBones {
                    subBone.boneAlpha = newValue
                }
            }
        }
    }
    
    override var backgroundColor: UIColor?{
        get {
            super.backgroundColor
        }
        
        set {
            super.backgroundColor = newValue
            if !subBones.isEmpty {
                for subBone in subBones {
                    subBone.backgroundColor = newValue
                }
            }
        }
    }
    
    init(point: CGPoint, size: CGSize){
        super.init(frame: CGRect(origin: point, size: size))
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
    }
    
    func pictoBoneViewInit(color: UIColor, cornerRadius: CGFloat, borderWidth: CGFloat){
        
        self.backgroundColor = color
        
        self.layer.cornerRadius = cornerRadius
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor.black.cgColor
        
    }
    
    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        
        guard let boneView = view as? PictoBoneView else {
            return
        }
        
        let frame = boneView.frame
        boneView.anchorPoint = CGPoint(x: 0.5, y: 0)
        boneView.frame = frame
        
        self.subBones.append(boneView)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if !self.subBones.isEmpty {
            for subBone in self.subBones {
                let hitPoint = subBone.convert(point, from: self)
                
                if let hitSubView = subBone.hitTest(hitPoint, with: event) {
                    return hitSubView
                }
                
                if subBone.bounds.contains(hitPoint) {
                        return subBone
                }
            }
        }
        
        if let hitView = super.hitTest(point, with: event){
            return hitView
        }
        
        return nil
    }
    
    func allSubBones() -> [PictoBoneView] {
        var allSubBones: [PictoBoneView] = [self]
        for subBone in self.subBones {
            if subBone.subBones.isEmpty {
                allSubBones += [subBone]
                continue
            }
            allSubBones += subBone.allSubBones()
        }
        return allSubBones
    }
    
    func rotated(by angle: CGFloat) {
        
        let rotationAngle = -(self.angle - angle)
        self.angle = angle
        DispatchQueue.main.async {
            self.transform = self.transform.rotated(by: rotationAngle)
        }
    }
}
