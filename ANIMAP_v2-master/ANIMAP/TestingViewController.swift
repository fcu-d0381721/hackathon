//
//  TestingViewController.swift
//  ANIMAP
//
//  Created by 謝忠穎 on 2017/7/4.
//  Copyright © 2017年 Winky_swl. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Firebase
import SDWebImage


class TestingViewController: UIViewController {
    
    private var videoURL: URL
    var fullscreen : CGRect?
    var player: AVPlayer?
    var playerController : AVPlayerViewController?
    var videoId: String?
    var screenurl: URL?

    var seen = 0
    
    var ref: DatabaseReference!
    var newref: DatabaseReference!

    var totalRef: DatabaseReference!
    
    var videouid: String?
    
    init(videoURL: String, id: String, screenurl: String, videouid: String) {
        let url = NSURL(string: videoURL)
        self.videoURL = url as! URL
        self.videoId = id
        self.videouid = videouid
        
        let urlscreen = NSURL(string: screenurl)
        self.screenurl = urlscreen as! URL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(screenurl)
        
        
        
        // Do any additional setup after loading the view.
        // init full screen
        fullscreen = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        getVideoData()
        
        
        player = AVPlayer(url: videoURL)
        playerController = AVPlayerViewController()
        
        guard player != nil && playerController != nil else {
            return
        }
        playerController!.showsPlaybackControls = false
        
        playerController!.player = player!
        self.addChildViewController(playerController!)
        self.view.addSubview(playerController!.view)
        playerController!.view.frame = view.frame
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)

        let cancelButton = UIButton(frame: CGRect(x: 15.0, y: 15.0, width: 30.0, height: 30.0))
        cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        


        view.addSubview(cancelButton)
        addTotalSeen()

    }
    
    func getVideoData(){
        newref = Database.database().reference().child("videos").child(videoId!).child("seen")
        newref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print(snapshot.key)
            if let seen = snapshot.value as? String {
                //Do not cast print it directly may be score is Int not string
                print(seen)
                self.seen = Int(seen)!
                self.seen += 1
                
                let seenObject = ["seen": String(self.seen)] as [String : Any]
                
                self.newref = Database.database().reference().child("videos").child(self.videoId!)
                self.newref.updateChildValues(seenObject)
            }else{
                print("NOOO")
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func addTotalSeen(){
        totalRef = Database.database().reference().child("users").child(self.videouid!).child("videoSeen")
        totalRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print(snapshot.value)
            if let totalseen = snapshot.value as? String {
                //Do not cast print it directly may be score is Int not string
                print(totalseen)
                var seenTemp = Int(totalseen)!
                seenTemp += 1
                
                let seenObject = ["videoSeen": String(seenTemp)] as [String : Any]
                
                self.totalRef = Database.database().reference().child("users").child(self.videouid!)
                self.totalRef.updateChildValues(seenObject)
            }else{
                print("NOOO")
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
        let imageview = UIImageView(frame: fullscreen!)
        imageview.sd_setImage(with: screenurl)
        view.addSubview(imageview)
    }
    
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player!.seek(to: kCMTimeZero)
            self.player!.play()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
