//
//  LoginViewController.swift
//  ANIMAP
//
//  Created by Winky_swl on 15/7/2017.
//  Copyright © 2017年 Winky_swl. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var appiconview: UIView!
    var ref: DatabaseReference!
    var addRef: DatabaseReference!
    var uid: String?
    
    var fbcustombutton = UIButton()
    
    var user: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        ref = Database.database().reference().child("users")
        addRef = Database.database().reference().child("users")
        
//        view.addSubview(loginButton)
//        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        
        //custom button 
        fbcustombutton = UIButton(type: .system)
        fbcustombutton.backgroundColor = .black
        fbcustombutton.frame = CGRect(x: 0, y: UIScreen.main.bounds.maxY-150, width: UIScreen.main.bounds.width - 100, height: 50)
        fbcustombutton.center.x = UIScreen.main.bounds.midX
        fbcustombutton.layer.cornerRadius = 5
        fbcustombutton.setTitle("Login With Facebook", for: .normal)
        fbcustombutton.setTitleColor(.white, for: .normal)
        fbcustombutton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        fbcustombutton.alpha = 1
        view.addSubview(fbcustombutton)
        
        fbcustombutton.addTarget(self, action: #selector(handlecustomfblogin), for: .touchUpInside)
        
  
    }
    
    func handlecustomfblogin(){
        FBSDKLoginManager().logIn(withReadPermissions:  ["email", "public_profile"], from: self)
        { (result, error) in
            if error != nil{
                print("fb custom login fail")
                return
            }
            self.showEmailAddress()
        }
        
      //  fbcustombutton.alpha = 0

        
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook.")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        islogin()
        
    }
    
    func islogin(){
        if(FBSDKAccessToken.current() != nil){
            // logged in
            print("login succesfully")
            fbcustombutton.alpha = 0

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier :"initview") as! UITabBarController
            self.present(vc, animated: true, completion: nil)
        }else{
            //fbcustombutton.alpha = 1

        }
    }
    

    
    func showEmailAddress() {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {
            print("按了完成")
            fbcustombutton.alpha = 1
            return
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            let origincenter = self.appiconview.center.y
            self.fbcustombutton.alpha = 0
            self.appiconview.center.y = origincenter + CGFloat(80)
        })
        
        
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Something went wrong with our facebook user", error ?? "")
                return
            }
            print("Successfully logged in with our facebook user", user ?? "")
            
//            print(user?.photoURL)
//            print(user?uid)
            
            self.uid = Auth.auth().currentUser?.uid
            
            self.ref = Database.database().reference().child("users").child(self.uid as! String)
            
            self.ref.observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                
                print(snapshot)
                
                if(snapshot.exists()) {
                    print("have user")
//                    print(snapshot.value)
                } else {
                    let imageurl = "https://graph.facebook.com/\(user?.providerData[0].uid as! String)/picture?type=large&return_ssl_resources=1"
                    
                    
                    
                    let userdata = ["id": self.uid as! String,
                                    "name": user?.displayName ?? String(),
                                    "imageurl": imageurl as! String,
                                    "email": user?.email ?? String(),
                                    "totalArticle": "0",
                                    "totalVideo": "0",
                                    "videoSeen": "0",
                                    "totalLike": "0",
                                    "totalAnswer": "0"] as [String : Any]
                    
                    self.addRef.child(self.uid as! String).setValue(userdata)
                    
                }
                
                
                
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier :"initview") as! UITabBarController
                self.present(vc, animated: true, completion: nil)
                
            }) { (error) in
                print("no user")
            }

        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "id, name, email"]).start { (connection, result, err) in
            if err != nil {
                print("Failed to start graph request: ", err ?? "")
                return
            }
            print(result ?? "")
        }
    
    }
    
}
