//
//  ProfileViewController.swift
//  SnapCycle
//
//  Created by Sion Daniel on 1/18/20.
//  Copyright © 2020 Sion Daniel. All rights reserved.
//

import UIKit
import CoreML

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate
{
    
    @IBOutlet weak var classifier: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        imageView.image = image
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 299, height: 299), true, 2.0)
        image.draw(in: CGRect(x: 0, y: 0, width: 299, height: 299))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) //3
        
        context?.translateBy(x: 0, y: newImage.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        guard let prediction = try? recycle_84().prediction(image: pixelBuffer!) else {
            return
        }
        
        let confidence = ((prediction.classLabelProbs[prediction.classLabel] ?? 0)*100.0)
        let confidence_round = String(format: "%.2f", confidence)
        
        
        
        let initialPrint = String(prediction.classLabel.capitalized + "\nConfidence: " + confidence_round + "%")
        
        if confidence > 75.0{
            if prediction.classLabel.isEqual("plastic") || prediction.classLabel.isEqual("metal") || prediction.classLabel.isEqual("glass") || prediction.classLabel.isEqual("cardboard") || prediction.classLabel.isEqual("paper"){
                classifier.text = initialPrint + "\n RECYCLE!"
            }
        }else{
            classifier.text = "Unable to Detect"
        }
        
    }
    
    
}
