//
//  EditView.swift
//  Point
//
//  Created by 小林千浩 on 2022/11/19.
//

import UIKit

class EditView: UIView {
    
    var moveFlag: Bool = false
    var object: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touchesEvent = touches.first, let touchesView = touchesEvent.view as? PictoBoneView else {
            return
        }
        
        let touchesLocation = touchesEvent.location(in: touchesView.superview)
        let targetCenter = touchesView.center
        
        if moveFlag {
            let previousLocation = touchesEvent.previousLocation(in: touchesView.superview)
            let point = CGPoint(x: touchesLocation.x-previousLocation.x, y: touchesLocation.y-previousLocation.y)
            guard let pictoView = self.object as? PictoView else {return}
            pictoView.moved(point: point)
        }else{
            let angle = atan2(targetCenter.y-touchesLocation.y, targetCenter.x-touchesLocation.x)
            touchesView.rotated(by: angle)
        }
        
    }
    
    func toImage(_ transparent: Bool = true) -> UIImage?{
        
        let color = self.backgroundColor
        if transparent {
            self.backgroundColor = .clear
        }
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else{
            return nil
        }
        layer.render(in: context)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if transparent {
            if let data = image?.pngData() {
                image = UIImage(data: data)
            }
        }
        
        self.backgroundColor = color
        
        return image
        
    }
}
