//
//  ViewController.swift
//  pictoMaker
//
//  Created by 小林千浩 on 2023/06/21.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var editView: EditView!
    @IBOutlet weak var pictoView: PictoView!
    @IBOutlet weak var borderButton: Button!
    @IBOutlet weak var moveButton: Button!
    @IBOutlet weak var colorButton: UIColorWell!
    @IBOutlet weak var imageButton: Button!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = Bundle.main.url(forResource: "index.html", withExtension: "", subdirectory: ""){
            self.webView.loadFileURL(url, allowingReadAccessTo: url)
        }
        //self.webView.load(URLRequest(url: URL(string: "https://www.google.com/")!))
        
        self.colorButton.addAction(.init{_ in
            self.pictoView.allColor = self.colorButton.selectedColor ?? .green
        }, for: .allEvents)
    }
    
    @IBAction func borderButtonTapped(_ sender: Any) {
        
        if self.borderButton.flag{
            self.pictoView.allBorderWidth = 1
            self.borderButton.switchFlag()
        }else{
            self.pictoView.allBorderWidth = 0
            self.borderButton.switchFlag()
        }
    }
    
    @IBAction func moveButtonTapped(_ sender: Any) {
        self.moveButton.switchFlag()
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
