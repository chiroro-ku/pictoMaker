//
//  ViewController.swift
//  pictoMaker
//
//  Created by 小林千浩 on 2023/06/21.
//

import UIKit
import PhotosUI

import GoogleMobileAds

class ViewController: UIViewController {
    
    @IBOutlet weak var editView: EditView!
    @IBOutlet weak var pictoView: PictoView!
    @IBOutlet weak var borderButton: Button!
    @IBOutlet weak var moveButton: Button!
    @IBOutlet weak var colorButton: UIColorWell!
    @IBOutlet weak var imageButton: Button!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    var selection = [String: PHPickerResult]()
    var selectedAssetIdentifiers = [String]()
    var selectedAssetIdentifierIterator: IndexingIterator<[String]>?
    
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
    
    @IBAction func imageButtonTapped(_ sender: Any) {
        
        self.saveImageWithData()
        
    }
    
    func saveImage(){
        guard let uiImage = self.editView.toImage() else {
            self.saveImageError()
            return
        }
        UIImageWriteToSavedPhotosAlbum(uiImage, self, nil, nil)
        self.imageButton.setTitle("成功", for: .normal)
    }
    
    func saveImageWithData(){
        
        guard let uiImage = self.editView.toImage(),
              let imageData = uiImage.pngData(),
              let cgImageSource = CGImageSourceCreateWithData(imageData as CFData, nil),
              var metadata = CGImageSourceCopyPropertiesAtIndex(cgImageSource, 0, nil) as? [String: Any],
              var exifDictionary = metadata[kCGImagePropertyExifDictionary as String] as? [String: Any] else {
            self.saveImageError()
            return
        }
        
//        print(exifDictionary)
        
//        exifDictionary.updateValue(kCGImagePropertyExifUserComment as String, forKey: self.pictoView.toAngleData())
        exifDictionary[kCGImagePropertyExifUserComment as String] = self.pictoView.toAngleData()
        metadata[kCGImagePropertyExifDictionary as String] = exifDictionary
        
//        print(exifDictionary)
        
        guard let cgImage = CGImageSourceCreateImageAtIndex(cgImageSource, 0, nil) else {
            self.saveImageError()
            return
        }
        
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
    }
    
    func saveImageError() {
        self.imageButton.setTitle("エラー", for: .normal)
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
}

extension ViewController: PHPickerViewControllerDelegate {
    
    /*
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        let assetIds = results.compactMap(\.assetIdentifier)
        let result = PHAsset.fetchAssets(withLocalIdentifiers: assetIds, options: .none)
        let options = PHContentEditingInputRequestOptions()
        options.isNetworkAccessAllowed = true

        guard let firstObject = result.firstObject else { return }
        
        firstObject.requestContentEditingInput(with: options) { input, _ in
        /*
        firstObject.requestContentEditingInput(with: options, completionHandler: { (contentEditingInput, _) -> Void in
            
            let inputUrl = contentEditingInput?.fullSizeImageURL
            let inputImage = CoreImage.CIImage(contentsOf: inputUrl!)
            let exif:NSDictionary = inputImage!.properties["{Exif}"] as! NSDictionary
            print(exif.object(forKey: "UserComment") ?? "error")
            print(exif)
         */
            
            
            guard let inputUrl = input?.fullSizeImageURL, // 選択されたImageのURL
                  let cgImageSource = CGImageSourceCreateWithURL(inputUrl as CFURL, nil), // CGImageSourceを作成
                  let cgImage = CGImageSourceCreateImageAtIndex(cgImageSource, 0, nil), // 書き込み用のCGImageを作成
                  var metadata = CGImageSourceCopyPropertiesAtIndex(cgImageSource, 0, nil) as? [String: Any], // metadataを取得
                  var locationDic = metadata[kCGImagePropertyGPSDictionary as String] as? [String: Any] else { return } // Locationのmetadataを取り出す
            
            guard var exifDic = metadata[kCGImagePropertyExifDictionary as String] as? [String: Any] else { return }
            
//            print(metadata[kCGImagePropertyExifLensMake as String] ?? "error")
//            guard var exifDic = metadata[kCGImagePropertyExifDictionary as String] as? [String: Any] else { return }
//            print(exifDic)
//            print(metadata)
            
            print(locationDic[kCGImagePropertyGPSLatitude as String] ?? "error")
            print(locationDic[kCGImagePropertyGPSLongitude as String] ?? "error")
            print(exifDic[kCGImagePropertyExifUserComment as String] ?? "error")

            /*
            // 適当なロケーションに上書き
            locationDic[kCGImagePropertyGPSLatitude as String] = "35.70220"
            locationDic[kCGImagePropertyGPSLongitude as String] = "139.81530"
            exifDic[kCGImagePropertyExifUserComment as String] = self.pictoView.toAngleData()

            // 再度metadataに上書きする
            metadata[kCGImagePropertyGPSDictionary as String] = locationDic
//            metadata.updateValue("PictoAngleData", forKey: self.pictoView.toAngleData())
            metadata[kCGImagePropertyExifDictionary as String] = exifDic
             */
            
//            print(metadata)
        
//            // 適当なURLを指定
//            let tmpName = UUID().uuidString
//            let tmpUrl = NSURL.fileURL(withPath: NSTemporaryDirectory() + tmpName + ".jpeg")
//            if let destination = CGImageDestinationCreateWithURL(tmpUrl as CFURL, UTType.jpeg.identifier as CFString, 1, nil) {
//                CGImageDestinationAddImage(destination, cgImage, metadata as CFDictionary)
//                CGImageDestinationFinalize(destination)
//
//                PHPhotoLibrary.shared().performChanges({
//                    // アルバムに書き込み
//                    PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: tmpUrl)
//                }, completionHandler: { success, error in
//                    print("performChanges success: \(success), error: \(String(describing: error?.localizedDescription))")
//                })
//            }
        }
    }
     */
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider else {
            self.saveImageError()
            return
        }
        guard let typeIdentifer = itemProvider.registeredTypeIdentifiers.first else {
            self.saveImageError()
            return
        }
        if itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
            itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, error in
                
                guard let data = data,
                      let cgImageSource = CGImageSourceCreateWithData(data as CFData, nil),
                      let metadata = CGImageSourceCopyPropertiesAtIndex(cgImageSource, 0, nil) as? [String: Any],
                      let exifDictionary = metadata[kCGImagePropertyExifDictionary as String] as? [String: Any],
                      let angleData = exifDictionary[kCGImagePropertyExifUserComment as String] as? String else {
                    self.saveImageError()
                    return
                }
                
                self.pictoView.loadAngleData(data: angleData)

            }
        }
        
    }
      
}
