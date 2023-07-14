//
//  PictoView.swift
//  pictoMaker
//
//  Created by 小林千浩 on 2023/06/22.
//

import UIKit

@IBDesignable final class PictoView: PictoBoneView {
    
    @IBInspectable var allCornerRadius: CGFloat {
        get{
            self.cornerRadius
        }
        
        set{
            self.cornerRadius = newValue
        }
    }
    
    @IBInspectable var allBorderWidth: CGFloat {
        get{
            self.borderWidth
        }
        
        set{
            self.borderWidth = newValue
        }
    }
    
    @IBInspectable var allAlpha: CGFloat {
        get{
            self.boneAlpha
        }
        
        set{
            self.boneAlpha = newValue
        }
    }
    
    @IBInspectable var allColor: UIColor {
        get{
            self.backgroundColor ?? .green
        }
        
        set{
            self.backgroundColor = newValue
        }
    }
    
    var faceSize: CGSize = CGSize(width: 55, height: 55)
    var armSize: CGSize = CGSize(width: 20, height: 60)
    var legSize:CGSize = CGSize(width: 20, height: 60)
    
    var face: PictoBoneView!
    var rightUpperArm: PictoBoneView!
    var rightArm: PictoBoneView!
    var leftUpperArm: PictoBoneView!
    var leftArm: PictoBoneView!
    var rightUpperLeg: PictoBoneView!
    var rightLeg: PictoBoneView!
    var leftUpperLeg: PictoBoneView!
    var leftLeg: PictoBoneView!
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.pictoInit()
        self.angle = Double.pi/2
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.pictoInit()
        self.angle = Double.pi/2
        
    }
    
    func pictoInit() {
        
        var selfWidth = self.bounds.width
        var selfHeight = self.bounds.height
        
        if selfWidth == 0 {
            selfWidth = 60
        }
        if selfHeight == 0 {
            selfHeight = 120
        }
        
        
        self.face = PictoFaceView(point: CGPoint(x: selfWidth/2-self.faceSize.width/2, y: -self.faceSize.height), size: self.faceSize)
        self.rightUpperArm = PictoBoneView(point: CGPoint(x: selfWidth-self.armSize.width/2, y: 0), size: armSize)
        self.rightArm = PictoBoneView(point: CGPoint(x: 0, y: self.armSize.height), size: self.armSize)
        self.leftUpperArm = PictoBoneView(point: CGPoint(x: -self.armSize.width/2, y: 0), size: self.armSize)
        self.leftArm = PictoBoneView(point: CGPoint(x: 0, y: self.armSize.height), size: self.armSize)
        self.rightUpperLeg = PictoBoneView(point: CGPoint(x: selfWidth-self.legSize.width, y: selfHeight), size: legSize)
        self.rightLeg = PictoBoneView(point: CGPoint(x: 0, y: self.legSize.height), size: self.legSize)
        self.leftUpperLeg = PictoBoneView(point: CGPoint(x: 0, y: selfHeight), size: self.legSize)
        self.leftLeg = PictoBoneView(point: CGPoint(x: 0, y: self.legSize.height), size: self.legSize)
        
        self.addSubview(self.face)
        self.addSubview(self.rightUpperArm)
        self.rightUpperArm.addSubview(self.rightArm)
        self.addSubview(self.leftUpperArm)
        self.leftUpperArm.addSubview(self.leftArm)
        self.addSubview(self.rightUpperLeg)
        self.rightUpperLeg.addSubview(self.rightLeg)
        self.addSubview(self.leftUpperLeg)
        self.leftUpperLeg.addSubview(self.leftLeg)
        
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func moved(point: CGPoint){
        var center = self.center
        center.x += point.x
        center.y += point.y
        self.center = center
    }
    
    func toAngleData() -> String {
        let bones = self.allSubBones()
        var angleDatas: [String] = []
        for bone in bones {
            angleDatas += ["\(bone.angle)"]
        }
        let angleData = angleDatas.joined(separator: ",")
        return angleData
    }
    
    func loadAngleData(data: String) {
        let angleDatas :[String] = data.components(separatedBy: ",")
        self.rotated(by: CGFloat(Double(angleDatas[0]) ?? 0.0))
        self.face.rotated(by: CGFloat(Double(angleDatas[1]) ?? 0.0))
        self.rightUpperArm.rotated(by: CGFloat(Double(angleDatas[2]) ?? 0.0))
        self.rightArm.rotated(by: CGFloat(Double(angleDatas[3]) ?? 0.0))
        self.leftUpperArm.rotated(by: CGFloat(Double(angleDatas[4]) ?? 0.0))
        self.leftArm.rotated(by: CGFloat(Double(angleDatas[5]) ?? 0.0))
        self.rightUpperLeg.rotated(by: CGFloat(Double(angleDatas[6]) ?? 0.0))
        self.rightLeg.rotated(by: CGFloat(Double(angleDatas[7]) ?? 0.0))
        self.leftUpperLeg.rotated(by: CGFloat(Double(angleDatas[8]) ?? 0.0))
        self.leftLeg.rotated(by: CGFloat(Double(angleDatas[9]) ?? 0.0))
    }
}
