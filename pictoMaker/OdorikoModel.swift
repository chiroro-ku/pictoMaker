//
//  OdorikoModel.swift
//  Point
//
//  Created by 小林千浩 on 2022/11/19.
//

import Foundation
import UIKit

class OdorikoModel{
    
    var face: BoneView!
    var body: BoneView
    var rightUpperArm: BoneView!
    var rightArm: BoneView!
    var leftUpperArm: BoneView!
    var leftArm: BoneView!
    var rightUpperLeg: BoneView!
    var rightLeg: BoneView!
    var leftUpperLeg: BoneView!
    var leftLeg: BoneView!
    
    var color: UIColor = .green
    
    var faceSize = CGSize(width: 55, height: 55)
    var boneSize = CGSize(width: 20, height: 60)
    var bodySize = CGSize(width: 60, height: 120)
    
    init(center point:CGPoint){
        
        self.body = BoneView(body: CGRect(origin: CGPoint(x: point.x - bodySize.width/2, y: point.y), size: bodySize), color: color)
        
        self.face = BoneView(frame: CGRect(origin: CGPoint(x: faceSize.width/2, y: -faceSize.height), size: faceSize), color: color)
        self.face.layer.cornerRadius = face.frame.width/2
        
        self.rightUpperArm = BoneView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: boneSize), color: color)
        self.rightArm = BoneView(frame: CGRect(origin: CGPoint(x: rightUpperArm.frame.width/2, y: rightUpperArm.frame.height), size: boneSize), color: color)
        
        self.leftUpperArm = BoneView(frame: CGRect(origin: CGPoint(x: body.frame.width, y: 0), size: boneSize), color: color)
        self.leftArm = BoneView(frame: CGRect(origin: CGPoint(x: leftUpperArm.frame.width/2, y: rightUpperArm.frame.height), size: boneSize), color: color)
        
        self.rightUpperLeg = BoneView(frame: CGRect(origin: CGPoint(x: boneSize.width/2, y: bodySize.height), size: boneSize), color: color)
        self.rightLeg = BoneView(frame: CGRect(origin: CGPoint(x: rightUpperLeg.frame.width/2, y: rightUpperLeg.frame.height), size: boneSize), color: color)
        
        self.leftUpperLeg = BoneView(frame: CGRect(origin: CGPoint(x: body.frame.width-boneSize.width/2, y: body.frame.height), size: boneSize), color: color)
        self.leftLeg = BoneView(frame: CGRect(origin: CGPoint(x: leftUpperLeg.frame.width/2, y: leftUpperLeg.frame.height), size: boneSize), color: color)
        
        self.body.addSubBoneView(face, CGPoint(x: 0.5, y: 1.0), Double.pi/2)
        self.body.addSubBoneView(rightUpperArm)
        self.rightUpperArm.addSubBoneView(rightArm)
        self.body.addSubBoneView(leftUpperArm)
        self.leftUpperArm.addSubBoneView(leftArm)
        self.body.addSubBoneView(rightUpperLeg)
        self.rightUpperLeg.addSubBoneView(rightLeg)
        self.body.addSubBoneView(leftUpperLeg)
        self.leftUpperLeg.addSubBoneView(leftLeg)
    }
    
    func centerBody() -> BoneView{
        return self.body
    }
    
    func colorChange(color: UIColor){
        self.face.backgroundColor = color
        self.body.backgroundColor = color
        self.rightUpperArm.backgroundColor = color
        self.rightArm.backgroundColor = color
        self.leftUpperArm.backgroundColor = color
        self.leftArm.backgroundColor = color
        self.rightUpperLeg.backgroundColor = color
        self.rightLeg.backgroundColor = color
        self.leftUpperLeg.backgroundColor = color
        self.leftLeg.backgroundColor = color
    }
}
