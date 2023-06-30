//
//  BoneView.swift
//  Point
//
//  Created by 小林千浩 on 2022/11/19.
//

import UIKit

class BoneView: UIView {
    
    var subBones: [BoneView]! = []
    var angle:CGFloat = -Double.pi/2

    init(point: CGPoint, color: UIColor) {
        let boneSize = CGSize(width: 30, height: 100)
        let bonePoint = CGPoint(x: point.x-boneSize.width/2, y: point.y)
        
        super.init(frame: CGRect(origin: bonePoint, size: boneSize))
        
        self.backgroundColor = color
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    init(frame: CGRect, color: UIColor) {
        let bonePoint = CGPoint(x: frame.origin.x - frame.width/2, y: frame.origin.y)
        
        super.init(frame: CGRect(origin: bonePoint, size: frame.size))
        
        self.backgroundColor = color
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    init(body frame: CGRect, color: UIColor) {
        
        super.init(frame: frame)
        
        self.backgroundColor = color
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubBoneView(_ view: BoneView, _ anchorPoint: CGPoint = CGPoint(x: 0.5, y: 0), _ angle: CGFloat =  -Double.pi/2){
        super.addSubview(view)
        
        let frame = view.frame
        view.anchorPoint = anchorPoint
        view.frame = frame
        
        view.angle = angle
        
        self.subBones.append(view)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if !subBones.isEmpty {
            for subBone in subBones {
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
    
    func rotated(by anAngle: CGFloat){
        let boneRotationAngle = -(self.angle - anAngle)
        self.angle = anAngle
        self.transform = self.transform.rotated(by: boneRotationAngle)
        
        //let boneRotationAngle = anAngle + Double.pi * 90 / 180.0
        //self.transform = CGAffineTransformMakeRotation(boneRotationAngle)
    }
}

