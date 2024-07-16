//
//  ViewController.swift
//  pictoMaker
//
//  Created by 小林千浩 on 2023/06/21.
//

import UIKit
import PhotosUI

//import GoogleMobileAds

class ViewController: UIViewController {
    
    @IBOutlet weak var editView: EditView!
    @IBOutlet weak var pictoView: PictoView!
    @IBOutlet weak var borderButton: Button!
    @IBOutlet weak var moveButton: Button!
    @IBOutlet weak var resetButton: Button!
    @IBOutlet weak var colorButton: UIColorWell!
    @IBOutlet weak var saveButton: Button!
    @IBOutlet weak var loadButton: Button!
    
    @IBOutlet weak var label: UILabel!
    
//    @IBOutlet weak var bannerView: GADBannerView!
    
    var selection = [String: PHPickerResult]()
    var selectedAssetIdentifiers = [String]()
    var selectedAssetIdentifierIterator: IndexingIterator<[String]>?
    
    enum LabelText: String {
        case normal = "ぐるぐる回転できるよ。"
        case border = "パーツの枠を可視化させるよ。"
        case move = "胴体を掴んで移動できるよ。"
        case reset = "僕を中央に移動させるよ。"
        case color = "色が変わっちゃった。"
        case save = "はい、チーズ。…保存できたよ。"
        case saveError = "はい、チーズ。…失敗したみたい。"
        case load = "ポーズを読み込んだよ。"
        case loadError = "ポーズが難しくて失敗しちゃった。"
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.editView.object = self.pictoView
        
        self.pictoView.center = CGPoint(x: self.editView.bounds.width/2, y: self.editView.bounds.height/2)
        
        self.label.text = LabelText.normal.rawValue
        
        self.colorButton.addAction(.init{_ in
            self.pictoView.allColor = self.colorButton.selectedColor ?? .green
            self.label.text = LabelText.color.rawValue
        }, for: .allEvents)
        
//        bannerView.adUnitID = ""
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pictoView.center = CGPoint(x: self.editView.bounds.width/2, y: self.editView.bounds.height/2)
    }
    
    @IBAction func borderButtonTapped(_ sender: Any) {
        
        if self.borderButton.flag {
            self.label.text = LabelText.border.rawValue
            self.pictoView.allBorderWidth = 1
            self.borderButton.tintColor = .white
            self.borderButton.backgroundColor = .systemBlue
            self.borderButton.switchFlag()
        }else{
            self.label.text = LabelText.normal.rawValue
            self.pictoView.allBorderWidth = 0
            self.borderButton.tintColor = .tintColor
            self.borderButton.backgroundColor = .systemBackground
            self.borderButton.switchFlag()
        }
        
    }
    
    @IBAction func moveButtonTapped(_ sender: Any) {
        
        if self.moveButton.flag {
            self.label.text = LabelText.move.rawValue
            self.editView.moveFlag = true
            self.moveButton.tintColor = .white
            self.moveButton.backgroundColor = .systemBlue
            self.moveButton.switchFlag()
            self.pictoView.layer.borderWidth = 2
            self.pictoView.boneAlpha = 0.6
            self.pictoView.alpha = 1
        }else{
            self.label.text = LabelText.normal.rawValue
            self.editView.moveFlag = false
            self.moveButton.tintColor = .tintColor
            self.moveButton.backgroundColor = .systemBackground
            self.moveButton.switchFlag()
            self.pictoView.layer.borderWidth = 0
            self.pictoView.boneAlpha = 1
        }
        
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        self.label.text = LabelText.reset.rawValue
        self.pictoView.center = CGPoint(x: self.editView.bounds.width/2, y: self.editView.bounds.height/2)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        self.saveImageWithData()
//        self.saveButton.setTitle("成功", for: .normal)
        
    }
    
    func saveImage(){
        
        guard let uiImage = self.editView.toImage() else {
            self.saveImageError()
            return
        }
        UIImageWriteToSavedPhotosAlbum(uiImage, self, nil, nil)
        
    }
    
    func saveImageWithData(){
        
        guard let uiImage = self.editView.toImage(),
              let imageData = uiImage.pngData(),
              let cgImageSource = CGImageSourceCreateWithData(imageData as CFData, nil),
              let cgImage = CGImageSourceCreateImageAtIndex(cgImageSource, 0, nil),
              var metadata = CGImageSourceCopyPropertiesAtIndex(cgImageSource, 0, nil) as? [String: Any],
              var exifDictionary = metadata[kCGImagePropertyExifDictionary as String] as? [String: Any] else {
            self.saveImageError()
            return
        }
        
        exifDictionary[kCGImagePropertyExifUserComment as String] = self.pictoView.toAngleData()
        metadata[kCGImagePropertyExifDictionary as String] = exifDictionary
        
        let tmpName = UUID().uuidString
        let tmpUrl = NSURL.fileURL(withPath: NSTemporaryDirectory() + tmpName + ".png")
        
        if let destination = CGImageDestinationCreateWithURL(tmpUrl as CFURL, UTType.png.identifier as CFString, 1, nil) {
            
            CGImageDestinationAddImage(destination, cgImage, metadata as CFDictionary)
            CGImageDestinationFinalize(destination)
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: tmpUrl)
            }, completionHandler: { success, error in
                print("performChanges success: \(success), error: \(String(describing: error?.localizedDescription))")
            })
            
        }
        
        self.label.text = LabelText.save.rawValue
        
    }
    
    func saveImageError() {
        
        self.label.text = LabelText.saveError.rawValue
        return
        
    }
    
    @IBAction func loadImageButton(_ sender: Any) {
        
        self.loadImage()
        
    }
    
    func loadImage(){
        
        let photoLibrary = PHPhotoLibrary.shared()
        var configuration = PHPickerConfiguration(photoLibrary: photoLibrary)
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        
    }
    
    func loadImageError() {
        
        DispatchQueue.main.async {
            self.label.text = LabelText.loadError.rawValue
        }
        
    }
    
    func loadImageData(){
        
        DispatchQueue.main.async {
            self.label.text = LabelText.load.rawValue
        }
        
    }
}

extension ViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider else {
            self.loadImageError()
            return
        }
        
        if itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
            itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, error in
                
                guard let data = data,
                      let cgImageSource = CGImageSourceCreateWithData(data as CFData, nil),
                      let metadata = CGImageSourceCopyPropertiesAtIndex(cgImageSource, 0, nil) as? [String: Any],
                      let exifDictionary = metadata[kCGImagePropertyExifDictionary as String] as? [String: Any],
                      let angleData = exifDictionary[kCGImagePropertyExifUserComment as String] as? String else {
                    self.loadImageError()
                    return
                }
                
                self.pictoView.loadAngleData(data: angleData)
                self.loadImageData()
                
            }
            
            
        }
        
    }
    
}

extension Button {
    func saveImage(_ transparent: Bool = true) {
        
        let color = self.backgroundColor
        if transparent {
            self.backgroundColor = .clear
        }
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else{
            return
        }
        layer.render(in: context)
        guard var image = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        
        if transparent {
            self.backgroundColor = color
        }
        
        guard let data = image.pngData(),
              let newImage = UIImage(data: data) else { return }
        image = newImage
        
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        
    }
}
