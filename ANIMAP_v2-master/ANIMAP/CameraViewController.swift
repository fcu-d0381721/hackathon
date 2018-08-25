//
//  CameraViewController.swift
//  TabBarExample
//
//  Created by Winky_swl on 4/6/2017.
//  Copyright © 2017年 Winky_swl. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
      
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
  
        //Set tabBarItem image
        self.tabBarItem.selectedImage = UIImage(named: "CameraClicked")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.tabBarItem.image = UIImage(named: "Camera")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }

    var camera = UIButton()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let newVC = CameraViewViewController()
        self.present(newVC, animated: true, completion: nil)
        
        self.tabBarController?.selectedIndex = 0
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func buttonAction(sender: UIButton!) {
//        print("tew5t")
//        //
//        let newVC = CameraViewViewController()
//        self.present(newVC, animated: true, completion: nil)
//    }
    
    
}
