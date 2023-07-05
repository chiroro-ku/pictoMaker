//
//  ViewController.swift
//  pictoMaker
//
//  Created by 小林千浩 on 2023/06/21.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController {
    
    @IBOutlet weak var editView: EditView!
    @IBOutlet weak var pictoView: PictoView!
    @IBOutlet weak var borderButton: Button!
    @IBOutlet weak var moveButton: Button!
    @IBOutlet weak var colorButton: UIColorWell!
    @IBOutlet weak var imageButton: Button!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.colorButton.addAction(.init{_ in
            self.pictoView.allColor = self.colorButton.selectedColor ?? .green
        }, for: .allEvents)
        
        self.pictoView.center = CGPoint(x: self.editView.bounds.width/2, y: self.editView.bounds.height/2)
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
    }
    
    @IBAction func borderButtonTapped(_ sender: Any) {
        
        if self.borderButton.flag {
            self.pictoView.allBorderWidth = 1
            self.borderButton.tintColor = .white
            self.borderButton.backgroundColor = .systemBlue
            self.borderButton.switchFlag()
        }else{
            self.pictoView.allBorderWidth = 0
            self.borderButton.tintColor = .tintColor
            self.borderButton.backgroundColor = .systemBackground
            self.borderButton.switchFlag()
        }
        
    }
    
    @IBAction func moveButtonTapped(_ sender: Any) {
        
        if self.moveButton.flag {
            self.editView.moveFlag = true
            self.moveButton.tintColor = .white
            self.moveButton.backgroundColor = .systemBlue
            self.moveButton.switchFlag()
            self.pictoView.layer.borderWidth = 1
        }else{
            self.editView.moveFlag = false
            self.moveButton.tintColor = .tintColor
            self.moveButton.backgroundColor = .systemBackground
            self.moveButton.switchFlag()
            self.pictoView.layer.borderWidth = 0
        }
        
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        self.pictoView.center = CGPoint(x: self.editView.bounds.width/2, y: self.editView.bounds.height/2)
    }
    
    @IBAction func imageButtonTapped(_ sender: Any) {
        self.imageButton.setTitle("...", for: .normal)
        guard let image = self.editView.toImage() else {
            self.imageButton.setTitle("Failure", for: .normal)
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        self.imageButton.setTitle("OK", for: .normal)
    }
}
