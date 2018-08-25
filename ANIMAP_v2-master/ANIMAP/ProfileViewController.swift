//
//  ProfileViewController.swift
//  TabBarExample
//
//  Created by Winky_swl on 4/6/2017.
//  Copyright © 2017年 Winky_swl. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import FBSDKLoginKit

class ProfileViewController: UIViewController {

    var ref: DatabaseReference!

    @IBOutlet weak var achievement: UILabel!
    @IBOutlet weak var totalScore: UILabel!
    @IBOutlet weak var totalAnswer: UILabel!
    @IBOutlet weak var totalLike: UILabel!
    @IBOutlet weak var totalArticle: UILabel!
    @IBOutlet weak var totalVideo: UILabel!
    @IBOutlet weak var totalSeen: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var midview: UIView!
    @IBOutlet weak var profilehead: UIImageView!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    var userData = User()
    var uid: String?

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //Set tabBarItem image
        self.tabBarItem.selectedImage = UIImage(named: "ProfileClicked")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.tabBarItem.image = UIImage(named: "Profile")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        midview.frame.size.width = self.view.bounds.width/4
        initimage()
        
         getData()
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        print("!!!")
        if Auth.auth().currentUser != nil {
            do {
                try? Auth.auth().signOut()
            }
            
            if Auth.auth().currentUser == nil {
                let loginManager: FBSDKLoginManager = FBSDKLoginManager()
                loginManager.logOut()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier :"login") as! LoginViewController
                self.present(vc, animated: true, completion: nil)
            }
        }
 
        
    }
    
    func initimage(){
        
        profilehead.contentMode = .scaleAspectFill
        profilehead.layer.masksToBounds = true
        profilehead.layer.cornerRadius = profilehead.bounds.width/2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        self.uid = Auth.auth().currentUser?.uid
        print(uid as! String)

        ref = Database.database().reference().child("users").child(uid as! String)
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                //clearing the list
                
                //iterating through all the values
                
                    //getting values
                    let value = snapshot.value as? NSDictionary
                
                    self.userData.email = value?["email"] as! String
                    self.userData.imageurl = value?["imageurl"] as! String
                    self.userData.name = value?["name"] as? String
                    self.userData.totalArticle = value?["totalArticle"] as! String
                    self.userData.totalVideo = value?["totalVideo"] as! String
                    self.userData.videoSeen = value?["videoSeen"] as! String
                    self.userData.totalLike = value?["totalLike"] as! String
                    self.userData.totalAnswer = value?["totalAnswer"] as! String
                
                
                    print(value?["email"] as! String)
                    print(value?["imageurl"] as! String)
                    print(value?["name"] as! String)
                    print(value?["totalVideo"] as! String)
                    print(value?["totalArticle"] as! String)
                    print(value?["videoSeen"] as! String)
                    
                    self.initInfo()
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    func initInfo() {
        let url = NSURL(string: userData.imageurl!)
        self.profilehead.sd_setImage(with: url as! URL)
        self.name.text = userData.name
        self.totalVideo.text = userData.totalVideo! + " 部"
        self.totalArticle.text = userData.totalArticle! + " 篇"
        self.totalSeen.text = userData.videoSeen
        self.totalAnswer.text = userData.totalAnswer! + " 次"
        self.totalLike.text = userData.totalLike! + " 個"
        
        
        
        self.totalScore.text = countScore()
        
    }
    
    func countScore () -> String {
        
        
        var videoScore = Int(userData.totalVideo!)! * 3
        var articleScore = Int(userData.totalArticle!)! * 2
        var likeScore = Int(userData.totalArticle!)! * 2
        var answerScore = Int(userData.totalAnswer!)!
        var seenScore = Int(Double(userData.videoSeen!)! * 0.5)
        
        var totalScore = videoScore + articleScore + likeScore + answerScore + seenScore
        
        print("!!!!!")
        print(totalScore)
        
        switch totalScore {
        case 0...100:
            achievement.text = "地區小菜鳥"
        case 101...300:
            achievement.text = "地區實習生"
        case 301...800:
            achievement.text = "地區小霸王"
        case 801...1200:
            achievement.text = "地區人氣王"
        default:
            achievement.text = "地區小菜鳥"
        }
        
        return String(totalScore)
    }
}
