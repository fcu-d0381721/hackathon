//
//  CameraViewViewController.swift
//  imgscroll
//
//  Created by 謝忠穎 on 2017/6/28.
//  Copyright © 2017年 謝忠穎. All rights reserved.
//

import UIKit
import SwiftyCam


class CameraViewViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate {
    
    
    var flipCameraButton: UIButton!
    var flashButton: UIButton!
    var captureButton: SwiftyRecordButton!
    var labelcoutdown: UILabel?
    var count = 0
    var timert : Timer?
    var labels :UILabel!
    
//
//    override var videoGravity: SwiftyCamVideoGravity{
//        return .resizeAspectFill
//    }
//    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    
        videoQuality = .iframe960x540
        cameraDelegate = self
        maximumVideoDuration = 8
        shouldUseDeviceOrientation = true
        allowAutoRotate = true
        audioEnabled = true
        addButtons()
       
     

    }
    
    func update(){
        if(count > 0){
            count = count - 1
            labelcoutdown?.text = String(count)
            print("count   \(count)")
        }else{
            labelcoutdown?.text = ""
        }
        
        print("update")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
//        let newVC = PhotoViewController(image: photo)
//        print(photo.size)
//        self.present(newVC, animated: true, completion: nil)
        showToast(message: "長按開始錄影")
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did Begin Recording")
        
        count = 8
        timert = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CameraViewViewController.update), userInfo: nil, repeats: true)
        
        captureButton.growButton()
        UIView.animate(withDuration: 0.25, animations: {
            self.flashButton.alpha = 0.0
            self.flipCameraButton.alpha = 0.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did finish Recording")
        captureButton.shrinkButton()
        UIView.animate(withDuration: 0.25, animations: {
            self.flashButton.alpha = 1.0
            self.flipCameraButton.alpha = 1.0
        })
        
        count = 0
        labelcoutdown?.text = ""
        timert?.invalidate()
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        let newVC = VideoViewController(videoURL: url)
        self.present(newVC, animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
        focusView.center = point
        focusView.alpha = 0.0
        view.addSubview(focusView)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1.0
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }, completion: { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }, completion: { (success) in
                focusView.removeFromSuperview()
            })
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        print(zoom)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        print(camera)
    }
    
    @objc private func cameraSwitchAction(_ sender: Any) {
        switchCamera()
    }
    
    @objc private func toggleFlashAction(_ sender: Any) {
        flashEnabled = !flashEnabled
        
        if flashEnabled == true {
            flashButton.setImage(#imageLiteral(resourceName: "flash"), for: UIControlState())
        } else {
            flashButton.setImage(#imageLiteral(resourceName: "flash_outline"), for: UIControlState())
        }
    }
    
    private func addButtons() {
        let cancelButton = UIButton(frame: CGRect(x: 15.0, y: 15.0, width: 25, height: 25))
        cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        self.view.addSubview(cancelButton)
        
        captureButton = SwiftyRecordButton(frame: CGRect(x: UIScreen.main.bounds.width/2 - 37.5, y: UIScreen.main.bounds.height - 100.0, width: 75.0, height: 75.0))
        self.view.addSubview(captureButton)
        captureButton.delegate = self
        
        flipCameraButton = UIButton(frame: CGRect(x: (((UIScreen.main.bounds.width / 2 - 37.5) / 2) - 15.0), y: UIScreen.main.bounds.height - 74.0, width: 30.0, height: 23.0))
        flipCameraButton.setImage(#imageLiteral(resourceName: "cameraSwitch"), for: UIControlState())
        flipCameraButton.addTarget(self, action: #selector(cameraSwitchAction(_:)), for: .touchUpInside)
        self.view.addSubview(flipCameraButton)
        
        let test = CGFloat((UIScreen.main.bounds.width - (UIScreen.main.bounds.width / 2 + 37.5)) + ((UIScreen.main.bounds.width / 2) - 37.5) - 9.0)
        
        flashButton = UIButton(frame: CGRect(x: test, y: UIScreen.main.bounds.height - 77.5, width: 18.0, height: 30.0))
        flashButton.setImage(#imageLiteral(resourceName: "flash_outline"), for: UIControlState())
        flashButton.addTarget(self, action: #selector(toggleFlashAction(_:)), for: .touchUpInside)
        self.view.addSubview(flashButton)
        
        
        labelcoutdown = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/2 - 37.5, y: 80, width: 75.0, height: 75.0))
        labelcoutdown?.textColor = UIColor.white
        labelcoutdown?.textAlignment =  NSTextAlignment.center
        labelcoutdown?.text = ""
        labelcoutdown?.font = labelcoutdown?.font.withSize(50)
        self.view.addSubview(labelcoutdown!)
        
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)


    }
    
    
}

extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.bounds.midY, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.5, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }
