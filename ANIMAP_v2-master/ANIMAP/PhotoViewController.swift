//
//  PhotoViewController.swift
//  imgscroll
//
//  Created by 謝忠穎 on 2017/6/29.
//  Copyright © 2017年 謝忠穎. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private var backgroundImage: UIImage
    
    init(image: UIImage) {
        self.backgroundImage = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.contentMode = UIViewContentMode.scaleAspectFit
        //backgroundImageView.frame = UIScreen.main.bounds
        backgroundImageView.image = backgroundImage
             print(UIScreen.main.bounds)
        view.addSubview(backgroundImageView)
        let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 10.0, width: 30.0, height: 30.0))
        cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
}
