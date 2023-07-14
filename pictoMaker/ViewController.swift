//
//  ViewController.swift
//  pictoMaker
//
//  Created by 小林千浩 on 2023/06/21.
//

import UIKit
import GoogleMobileAds
import Photos
import PhotosUI

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
        
        self.editView.object = self.pictoView
        
        self.pictoView.center = CGPoint(x: self.editView.bounds.width/2, y: self.editView.bounds.height/2)
        
        self.colorButton.addAction(.init{_ in
            self.pictoView.allColor = self.colorButton.selectedColor ?? .green
        }, for: .allEvents)
        
//        bannerView.adUnitID = ""
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
            self.pictoView.layer.borderWidth = 2
            self.pictoView.boneAlpha = 0.6
            self.pictoView.alpha = 1
        }else{
            self.editView.moveFlag = false
            self.moveButton.tintColor = .tintColor
            self.moveButton.backgroundColor = .systemBackground
            self.moveButton.switchFlag()
            self.pictoView.layer.borderWidth = 0
            self.pictoView.boneAlpha = 1
        }
        
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        self.pictoView.center = CGPoint(x: self.editView.bounds.width/2, y: self.editView.bounds.height/2)
    }
    
    func saveImage(){
        guard let uiImage = self.editView.toImage() else {
            self.saveImageError()
            return
        }
        UIImageWriteToSavedPhotosAlbum(uiImage, self, nil, nil)
        self.imageButton.setTitle("成功", for: .normal)
    }
    
    @IBAction func imageButtonTapped(_ sender: Any) {
        
        
        self.saveImage()
        
        /*
        
        guard let uiImage = self.editView.toImage() else {
            self.saveImageError()
            return
        }
        
        guard let imageData = uiImage.pngData() else {
            self.saveImageError()
            return
        }
        guard let cgImageSource = CGImageSourceCreateWithData(imageData as CFData, nil) else {
            self.saveImageError()
            return
        }
        //        var metadata = CGImageSourceCopyPropertiesAtIndex(cgImageSource, 0, nil) as? [String: Any]
        var metadata = CGImageSourceCopyProperties(cgImageSource, nil) as? [String: Any]
        /*
         var locationDictionary = metadata?[kCGImagePropertyGPSDictionary as String] as? [String: Any]
         locationDictionary?[kCGImagePropertyGPSLatitude as String] = "0.000"
         locationDictionary?[kCGImagePropertyGPSLongitude as String] = "0.000"
         */
        /*
         var locationDictionary = metadata?[kCGImagePropertyExifUserComment as String] as? [String: Any]
         if locationDictionary == nil {
         
         self.saveImageError()
         return
         }else{
         print(locationDictionary)
         }
         locationDictionary?[kCGImagePropertyExifUserComment as String] = self.angleData()
         metadata?[kCGImagePropertyGPSDictionary as String] = locationDictionary
         */
        metadata?[kCGImagePropertyExifUserComment as String] = self.pictoView.toAngleData()
        guard let cgImage = CGImageSourceCreateImageAtIndex(cgImageSource, 0, nil) else {
            self.saveImageError()
            return
        }
        let tmpName = UUID().uuidString
        let tmpUrl = NSURL.fileURL(withPath: NSTemporaryDirectory() + tmpName + ".png")
        if let destination = CGImageDestinationCreateWithURL(tmpUrl as CFURL, UTType.png.identifier as CFString, 1, nil) {
            guard let data = metadata else {
                self.saveImageError()
                return
            }
            CGImageDestinationAddImage(destination, cgImage, data as CFDictionary)
            CGImageDestinationFinalize(destination)
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: tmpUrl)
            }, completionHandler: { success, error in
                //                print("performChanges success: \(success), error: \(String(describing: error?.localizedDescription))")
            })
        }
        
        
        
        
        /*
         UIImageWriteToSavedPhotosAlbum(uiImage, self, nil, nil)
         */
        self.imageButton.setTitle("成功", for: .normal)
        
        /*
         let options = [
         kCGImageSourceCreateThumbnailWithTransform: true,
         kCGImageSourceCreateThumbnailFromImageAlways: true,
         kCGImageSourceThumbnailMaxPixelSize: 300] as [CFString : Any] as CFDictionary
         guard let imageReference = CGImageSourceCreateThumbnailAtIndex(cgImageSource, 0, options) else {
         self.saveImageError()
         return
         }
         let thumbnail = UIImage(cgImage: imageReference)
         */
         
         
         */
    }
    
    func saveImageError() {
        self.imageButton.setTitle("エラー", for: .normal)
        return
    }
    
    func loadImage(){
        /*
        //あとからPHAssetとして取得する場合は引数を指定。
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        //同時写真選択数。0で無制限
        config.selectionLimit = 1
        config.filter = PHPickerFilter.images
        
        let pickerViewController = PHPickerViewController(configuration: config)
        pickerViewController.delegate = self
        
        self.present(pickerViewController, animated: true, completion: nil)
        /*
         if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
         imagePicker.sourceType = .photoLibrary
         self.present(imagePicker, animated: true, completion: nil)
         }else{
         print("Photo Library not available.")
         }
         */
         */
    }
}
