//
//  FirstViewController.swift
//  TabBarExample
//
//  Created by Winky_swl on 2/6/2017.
//  Copyright © 2017年 Winky_swl. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import Cluster
import CoreLocation

class HomeViewController: UIViewController {
    
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var listContainerView: UIView!

    @IBOutlet weak var segmentedControl: UISegmentedControl!

    @IBOutlet weak var urgentView: UIView!
    @IBOutlet weak var reply: UIButton!
    @IBOutlet weak var close: UIButton!
    //    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)!
//        
//        //Set tabBarItem image
//
//    }

    @IBAction func test(_ sender: Any) {
        if self.urgentView.frame.origin.y == -85 {
            UIView.animate(withDuration: 1, animations: {
                self.urgentView.frame.origin.y = 69
            }, completion: nil)
        }
        else {
            UIView.animate(withDuration: 1, animations: {
                self.urgentView.frame.origin.y = -85
            }, completion: nil)
        }
    }
    
    @IBAction func viewSelect(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            mapContainerView.isHidden = false
            listContainerView.isHidden = true
        //show popular view
        case 1:
            mapContainerView.isHidden = true
            listContainerView.isHidden = false
        //show history view
        default:
            break;
        }
    }

    @IBAction func sendEvent(_ sender: Any) {
        
        if ShareManager.sharedInstance.sendEventAction == 0 {
            let sendEventVC = UIStoryboard(name:"Mainpage", bundle:nil).instantiateViewController(withIdentifier: "sendEvent") as! SendEventViewController
            
            self.addChildViewController(sendEventVC)
            sendEventVC.view.frame = self.view.frame
            self.view.addSubview(sendEventVC.view)
            sendEventVC.didMove(toParentViewController: self)
        }
        
        ShareManager.sharedInstance.sendEventAction = 1
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.tabBarItem.selectedImage = UIImage(named: "HomeClicked")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        self.navigationController?.tabBarItem.image = UIImage(named: "Home")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        mapContainerView.isHidden = false
        listContainerView.isHidden = true
   
        self.tabBarController?.tabBar.barTintColor = UIColor.white
        self.tabBarController?.tabBar.isTranslucent = false
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        urgent_init()
    }
    
    func urgent_init(){
        urgentView.frame.origin.y = -85
        
        urgentView.layer.cornerRadius = 5
        urgentView.layer.borderWidth = 1
        urgentView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        
        reply.layer.borderWidth = 1
        reply.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        
        close.layer.borderWidth = 1
        close.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
    }
    
    @IBAction func replyOnClick(_ sender: Any) {
        UIView.animate(withDuration: 1, animations: {
            self.urgentView.frame.origin.y = -85
        }, completion: { result -> Void in
            if ShareManager.sharedInstance.sendEventAction == 0 {
                let sendEventVC = UIStoryboard(name:"Mainpage", bundle:nil).instantiateViewController(withIdentifier: "sendEvent") as! SendEventViewController
                
                self.addChildViewController(sendEventVC)
                sendEventVC.view.frame = self.view.frame
                self.view.addSubview(sendEventVC.view)
                sendEventVC.didMove(toParentViewController: self)
            }
            
            ShareManager.sharedInstance.sendEventAction = 1
        })
    }
    
    func sendEvent(){
        if ShareManager.sharedInstance.sendEventAction == 0 {
            let sendEventVC = UIStoryboard(name:"Mainpage", bundle:nil).instantiateViewController(withIdentifier: "sendEvent") as! SendEventViewController
            
            self.addChildViewController(sendEventVC)
            sendEventVC.view.frame = self.view.frame
            self.view.addSubview(sendEventVC.view)
            sendEventVC.didMove(toParentViewController: self)
        }
        
        ShareManager.sharedInstance.sendEventAction = 1

    }
    
    @IBAction func closeOnClick(_ sender: Any) {
        UIView.animate(withDuration: 1, animations: {
            self.urgentView.frame.origin.y = -85
        }, completion: nil)
    }
    

    
}
