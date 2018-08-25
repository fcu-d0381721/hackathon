//
//  VideoViewController.swift
//  imgscroll
//
//  Created by 謝忠穎 on 2017/6/29.
//  Copyright © 2017年 謝忠穎. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Firebase
import CoreLocation

class VideoViewController: UIViewController,
    UICollectionViewDelegate,
UICollectionViewDataSource {
    
    var ref: DatabaseReference!
    var newref: DatabaseReference!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    let category = ["地區", "美食", "運動", "生活", "有趣"]
 
    var cates = "地區"
    
    var area = UIButton()
    var food = UIButton()
    var sport = UIButton()
    var life = UIButton()
    var fun = UIButton()
    
    var buttonview: UIView?
    
    var secc :UIScrollView!
    private var videoURL: URL
    var player: AVPlayer?
    var playerController : AVPlayerViewController?
    var fullscreen : CGRect?
    var blackview :UIView?
    let layout = UICollectionViewFlowLayout()
    var mycollectionView :UICollectionView?
    let progresslabel = UILabel()
    
    var latitude: Double?
    var longitude: Double?
    var randNum: String?

    
    
    var deletebutton: UIImageView?
    
    var canvasview: UIView?
    
    var nowtarget: UITextField?
    
    var textcolor = 0
    
    var colorbutton = UIButton()
    
    
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ref = Database.database().reference().child("videos")
        
        // init full screen
        fullscreen = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        canvasview = UIView(frame: fullscreen!)
        
        gpsInit()
        
        
        self.view.backgroundColor = UIColor.gray
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
        
        scrollviewInit()
        //stickerinit
        initCollectionview()
        
        setbuttongroup()
        
        let cancelButton = UIButton(frame: CGRect(x: 15.0, y: 15.0, width: 25, height: 25))
        cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        let stickerButton = UIButton(frame: CGRect(x: (fullscreen?.width)! - 45, y: 10.0, width: 30, height: 30))
        stickerButton.setImage(#imageLiteral(resourceName: "smiley"), for: UIControlState())
        stickerButton.addTarget(self, action: #selector(addstickerView), for: .touchUpInside)
        
        let letterbutton = UIButton(frame: CGRect(x: (fullscreen?.width)! - 45, y: 60, width: 30 , height: 30))
        letterbutton.setImage(#imageLiteral(resourceName: "letter"), for: UIControlState())
        letterbutton.addTarget(self, action: #selector(addlabel), for: .touchUpInside)
        
        let category = UIButton(frame: CGRect(x: (fullscreen?.width)! - 45, y: 110, width: 30 , height: 30))
        category.setImage(#imageLiteral(resourceName: "star"), for: UIControlState())
        category.addTarget(self, action: #selector(addcategory), for: .touchUpInside)
        
        let sendbutton = UIButton(frame: CGRect(x: (fullscreen?.width)! - 90, y: (fullscreen?.height)! - 60, width: 80, height: 35))
        sendbutton.setImage(#imageLiteral(resourceName: "send"), for: UIControlState())
        sendbutton.addTarget(self, action: #selector(uploadvideo), for: .touchUpInside)
        
        
        
//        let test = UIButton(frame: CGRect(x: 90, y: (fullscreen?.height)! - 60, width: 80, height: 35))
//        test.setImage(#imageLiteral(resourceName: "send"), for: UIControlState())
//        test.addTarget(self, action: #selector(test132), for: .touchUpInside)
//        
//        view.addSubview(test)
        
        self.view.addSubview(canvasview!)
        view.addSubview(stickerButton)
        view.addSubview(letterbutton)
        view.addSubview(sendbutton)
        view.addSubview(cancelButton)
        view.addSubview(category)

        addblackview()
        adddelete()
        colorbuttoninit()
        
        
    }
    
    func adddelete(){
        let batman = UIImage(named: "garbage")
        self.deletebutton = UIImageView(frame:CGRect(x: 0, y: 0, width: 30 , height: 30))
        self.deletebutton?.image = batman
        self.deletebutton?.center.x = UIScreen.main.bounds.midX
        self.deletebutton?.center.y = UIScreen.main.bounds.maxY - 40
        self.deletebutton?.contentMode = .scaleAspectFit
        self.deletebutton?.alpha = 0
        self.view.addSubview(deletebutton!)
    }
    
    func addblackview(){
        blackview  = UIView(frame: fullscreen!)
        blackview?.backgroundColor = UIColor(white: 0, alpha: 0.7)
        blackview?.isUserInteractionEnabled = true
        blackview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMenu)))
        blackview?.alpha = 0
        self.canvasview?.addSubview(blackview!)
        //self.view.addSubview(blackview!)

    }
    
    
    func gpsInit(){
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        let coordinate = locationManager.location?.coordinate
        
        if coordinate?.longitude != 0.0{
            latitude = coordinate?.latitude
            longitude = coordinate?.longitude
        }
    }
    
    func setbuttongroup(){
        
        buttonview = UIView(frame: fullscreen!)
        buttonview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMenu)))

        
        area = UIButton(frame: CGRect(x: (fullscreen?.midX)!, y: 100, width: 100, height: 50))
        area.setTitle("地區", for: .normal)
        area.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        area.center.x = (fullscreen?.midX)!
        area.layer.cornerRadius = 5
        area.layer.borderWidth = 1
        area.layer.borderColor = UIColor.white.cgColor
        area.addTarget(self, action: #selector(buttontap(sender:)), for: .touchUpInside)
        
        food = UIButton(frame: CGRect(x: (fullscreen?.midX)!, y: 180, width: 100, height: 50))
        food.setTitle("美食", for: .normal)
        food.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        food.center.x = (fullscreen?.midX)!
        food.layer.cornerRadius = 5
        food.layer.borderWidth = 0
        food.layer.borderColor = UIColor.white.cgColor
        food.addTarget(self, action: #selector(buttontap(sender:)), for: .touchUpInside)

        
        self.sport = UIButton(frame: CGRect(x: (fullscreen?.midX)!, y: 260, width: 100, height: 50))
        sport.setTitle("運動", for: .normal)
        sport.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        sport.center.x = (fullscreen?.midX)!
        sport.layer.cornerRadius = 5
        sport.layer.borderWidth = 0
        sport.layer.borderColor = UIColor.white.cgColor
        sport.addTarget(self, action: #selector(buttontap(sender:)), for: .touchUpInside)

        
        self.life = UIButton(frame: CGRect(x: (fullscreen?.midX)!, y: 340, width: 100, height: 50))
        life.setTitle("生活", for: .normal)
        life.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        life.center.x = (fullscreen?.midX)!
        life.layer.cornerRadius = 5
        life.layer.borderWidth = 0
        life.layer.borderColor = UIColor.white.cgColor
        life.addTarget(self, action: #selector(buttontap(sender:)), for: .touchUpInside)

        
        self.fun = UIButton(frame: CGRect(x: (fullscreen?.midX)!, y: 420, width: 100, height: 50))
        fun.setTitle("有趣", for: .normal)
        fun.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        fun.center.x = (fullscreen?.midX)!
        fun.layer.cornerRadius = 5
        fun.layer.borderWidth = 0
        fun.layer.borderColor = UIColor.white.cgColor
        fun.addTarget(self, action: #selector(buttontap(sender:)), for: .touchUpInside)

        
        self.buttonview?.addSubview(area)
        self.buttonview?.addSubview(food)
        self.buttonview?.addSubview(sport)
        self.buttonview?.addSubview(life)
        self.buttonview?.addSubview(fun)
        
        
        //self.buttonview?.backgroundColor = UIColor.blue
        self.buttonview?.alpha = 0
        
        //self.buttonview?.layer.shouldRasterize = true
        
        self.view.addSubview(buttonview!)
    }
    
    func addcategory(){
        self.view.bringSubview(toFront: blackview!)

        self.view.bringSubview(toFront: buttonview!)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.blackview?.alpha = 1
            self.buttonview?.alpha = 1
        })

    }
    
    func buttontap(sender: Any){
        let button =  sender as! UIButton
        area.layer.borderWidth = 0
        food.layer.borderWidth = 0
        sport.layer.borderWidth = 0
        life.layer.borderWidth = 0
        fun.layer.borderWidth = 0
        button.layer.borderWidth = 1
        
        cates = button.titleLabel?.text as! String
        print(cates)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
    
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player!.seek(to: kCMTimeZero)
            self.player!.play()
        }
    }
    
    func initCollectionview(){
        
        layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8)
        layout.minimumLineSpacing = 15
        
        layout.itemSize = CGSize(width:  CGFloat((fullscreen?.width)!)/5 - 13, height: CGFloat((fullscreen?.width)!)/5 - 13)
        
        // init collectionview
        mycollectionView = UICollectionView(frame: CGRect(x: 0, y: (fullscreen?.height)!, width: (fullscreen?.width)!, height: (fullscreen?.width)!), collectionViewLayout: layout)
        
        mycollectionView?.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        mycollectionView?.delegate = self as UICollectionViewDelegate
        mycollectionView?.dataSource = self as UICollectionViewDataSource
        mycollectionView?.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        
        self.view.addSubview(mycollectionView!)
    }
    
    
//    func test132(){
//         //dismiss(animated: true, completion: nil)
//        
//        let thisCV: UIViewController! = self
////
////        self.dismiss(animated: false) {
////            // go back to MainMenuView as the eyes of the user
////            thisCV.dismiss(animated: false, completion: nil)
////        }
//        
//        let url = NSURL(string: "https://firebasestorage.googleapis.com/v0/b/animap-3b23e.appspot.com/o/test.mov?alt=media&token=3b6dd74f-04ae-46f6-bc2b-0916a466a6e4")! as URL
////        let vc = TestingViewController(videoURL: "https://firebasestorage.googleapis.com/v0/b/animap-3b23e.appspot.com/o/test.mov?alt=media&token=17bc1ef5-bb78-472c-a3c9-8a5039b1b93b")
//        
//        self.dismiss(animated: true, completion: nil)
//        
//        thisCV.present(vc, animated: true, completion: nil)
//        
//        
//        
//    }
    
    func addlabel(){
        
        UIView.animate(withDuration: 0.5, animations: {
            self.blackview?.alpha = 1
        })
        
        canvasview?.bringSubview(toFront: blackview!)
        
        let label = UITextField(frame: CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: UIScreen.main.bounds.width, height: 50.0))
//        label = UITextField(frame: CGRect(x: Double(UIScreen.main.bounds.midX), y: Double(UIScreen.main.bounds.midY), width: self.view.frame.width, height: 50))
        label.center.x = UIScreen.main.bounds.midX
        label.center.y = UIScreen.main.bounds.midY - 20

        label.textAlignment =  NSTextAlignment.center
        label.text = "text"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.enablesReturnKeyAutomatically = true
        label.isUserInteractionEnabled = true
        label.becomeFirstResponder()
        
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(VideoViewController.pan(recognizer:)))
        pan.minimumNumberOfTouches = 1
        pan.maximumNumberOfTouches = 1
        label.addGestureRecognizer(pan)
        
        let singleFinger =
            UITapGestureRecognizer(target: self, action: #selector(VideoViewController.singleTap(recognizer:)))
        //singleFinger.require(toFail: doubleFingers)
        singleFinger.numberOfTapsRequired = 1
        singleFinger.numberOfTouchesRequired = 1
        label.addGestureRecognizer(singleFinger)
    
        
        label.addTarget(self, action: #selector(texteditbegin(sender:)), for: .editingDidBegin)
       
   
       // label.adjustsFontSizeToFitWidth = true


        canvasview?.addSubview(label)
        //self.view.addSubview(label!)
    }
    
    func colorbuttoninit(){
        colorbutton = UIButton(frame: CGRect(x: UIScreen.main.bounds.midX, y: -40, width: 40, height: 40))
        colorbutton.backgroundColor = UIColor(white: 0, alpha: 0.8)
        colorbutton.layer.borderWidth = 2.5
        colorbutton.layer.borderColor = UIColor.white.cgColor
        colorbutton.layer.cornerRadius = 20
        colorbutton.center.x = UIScreen.main.bounds.midX
        colorbutton.addTarget(self, action: #selector(colorchange(sender:)), for: .touchUpInside)
        colorbutton.alpha = 0
        self.view.addSubview(colorbutton)
        
    }
    
    func colorchange(sender: Any){
        let btn = sender as! UIButton
        
        
        if(textcolor == 0){
            nowtarget?.textColor = .black
            btn.backgroundColor = UIColor(white: 1, alpha: 0.8)
            textcolor = 1
        }else{
            nowtarget?.textColor = .white
            btn.backgroundColor = UIColor(white: 0, alpha: 0.8)
            textcolor = 0
        }

    }
    
    func texteditbegin(sender: Any){
        
        let target = sender as! UIView
        
        
        nowtarget = sender as! UITextField
        
        canvasview?.bringSubview(toFront: blackview!)
        canvasview?.bringSubview(toFront: sender as! UIView)
        
        
        
        UIView.animate(withDuration: 0.3, animations: {
            self.blackview?.alpha = 1
           target.center.x = UIScreen.main.bounds.midX
           target.center.y = UIScreen.main.bounds.midY
           self.colorbutton.center.y = 28
           self.colorbutton.alpha = 1

        })
    }
    
    
    func cancel() {
        
        dismiss(animated: true, completion: nil)        
    }
    
    func uploadvideo(){
        
        player?.pause()
        
        let someDate = Date()
        let timeInterval = someDate.timeIntervalSince1970
        
        randNum = "v\(Int(timeInterval*100000))"
        
        let filename = "\(randNum ?? String()).mov"
        let storage = Storage.storage().reference()
        print(videoURL)
        
        let mask  = UIView(frame: fullscreen!)
        mask.backgroundColor = UIColor(white: 0, alpha: 0.7)
        mask.isUserInteractionEnabled = true
        mask.tag = 100
        
        self.progresslabel.text = "Uploading ... \n 0/100"
        progresslabel.numberOfLines = 0
        progresslabel.textAlignment = .center
       // label.lineBreakMode
        progresslabel.textColor = .white
        progresslabel.translatesAutoresizingMaskIntoConstraints = false
        progresslabel.frame = CGRect(x: (fullscreen?.width)!/2-100 , y: (fullscreen?.height)!/2-120, width: 200.0, height: 200.0)
        progresslabel.font = UIFont.boldSystemFont(ofSize: 32)
        
        
        mask.addSubview(progresslabel)
        
        self.view.addSubview(mask)
        
        
        
        let uploadtask = storage.child(filename).putFile(from: videoURL as URL, metadata: nil){ metadata, error in
            if let error = error {
                print(error)
            }else{
                
                let download = metadata!.downloadURLs
                print("!!!!!!!!!!!!!!!")
                print(download)
                
                let date = Date()
                
//                videoItem.url = download?[0].path
//                videoItem.city = ShareManager.sharedInstance.city
//                videoItem.subArea = ShareManager.sharedInstance.subAdministrativeArea
//                videoItem.longitude = String(format:"%f", ShareManager.sharedInstance.longitude!)
//                videoItem.latitude = String(format:"%f", ShareManager.sharedInstance.latitude!);
//                videoItem.id = "v\(date.timeIntervalSince1970)"
//                videoItem.category = self.category[0]
                
                

                
                do {
                    let asset = AVURLAsset(url: self.videoURL , options: nil)
                    let imgGenerator = AVAssetImageGenerator(asset: asset)
                    imgGenerator.appliesPreferredTrackTransform = true
                    let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
                    let thumbnail = UIImage(cgImage: cgImage)
                    let conpressimage = self.resizeImage(image: thumbnail, targetSize: CGSize(width: 450, height: 800))
                    
                    var imgurl = ""
                    
                    
                    //asdasdasdasd
                    let data = UIImagePNGRepresentation(conpressimage) as NSData?
                    let uploadimage = storage.child(filename+"_image.png").putData(data as! Data, metadata: nil){ metadata, error in
                        if let error = error {
                            print(error)
                        }else{
                            print("image success upload")
                            imgurl = (metadata?.downloadURLs?[0].absoluteString)!
 
                            
                            
                            
                            UIGraphicsBeginImageContext((self.canvasview?.frame.size)!)
                            self.canvasview?.layer.render(in: UIGraphicsGetCurrentContext()!)
                            let image = UIGraphicsGetImageFromCurrentImageContext()
                            UIGraphicsEndImageContext()
                            
                            let data2 = UIImagePNGRepresentation(image!) as NSData?
                            
                            let uploadconvasview = storage.child(filename + "_screenshot.jpg").putData(data2 as! Data, metadata: nil){ metadata, error in
                                if let error = error {
                                    print(error)
                                }else{

                                    let videoItem = ["userid": ShareManager.sharedInstance.uid,
                                                     "latitude": String(format:"%f", self.latitude!),
                                                     "longitude": String(format:"%f", self.longitude!),
                                                     "city": ShareManager.sharedInstance.city,
                                                     "subArea": ShareManager.sharedInstance.subAdministrativeArea,
                                                     "id": self.randNum ?? String(),
                                                     "category": self.cates,
                                                     "imageurl": imgurl,
                                                     "screenurl": metadata?.downloadURLs?[0].absoluteString,
                                                     "url": download?[0].absoluteString,
                                                     "seen": "0"] as [String : Any]
                                    self.ref.child(self.randNum ?? String()).setValue(videoItem)
                                    print("screenshot OKK")
                                    
                                }
                            }
                            self.insertData()
                          
                        }
                    }
                    // thumbnail here
                    
                } catch let error {
                    print("*** Error generating thumbnail: \(error.localizedDescription)")
                }
                               // !! check the error before proceeding
                
                
                                let subViews = self.view.subviews
                for subview in subViews{
                    if subview.tag == 100 {
                        print("remove")
                        subview.removeFromSuperview()
                    }else{
                        print(subview.tag)
//                        let vc = TestingViewController(videoURL: (urlasd?[0])!)
//                        self.present(vc, animated: true, completion: nil)
                        
//                        self.dismiss(animated: true, completion: {
//                            self.dismiss(animated: true, completion: nil)
//                        })
                        
                    }
                }
               self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)


            }
        }
        
        let observer = uploadtask.observe(.progress) { snapshot in
            print(snapshot.progress) // NSProgress object
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            
         //   var myIntValue:Int = Int(percentComplete)
            
            let str = NSString(format:"%.2f",percentComplete)
           // println("\(str)")  //输出3.33

            
            self.progresslabel.text = "Uploading ... \n \(str) /100"
            
        }
        
    }

    func insertData(){
        self.newref = Database.database().reference().child("users").child(ShareManager.sharedInstance.uid!).child("totalVideo")
        self.newref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print(snapshot.key)
            if let totalVideo = snapshot.value as? String {
                //Do not cast print it directly may be score is Int not string
                print(totalVideo)
                var totalVideoTemp = Int(totalVideo)!
                totalVideoTemp += 1
                
                let totalVideoObject = ["totalVideo": String(totalVideoTemp)] as [String : Any]
                
                self.newref = Database.database().reference().child("users").child(ShareManager.sharedInstance.uid!)
                self.newref.updateChildValues(totalVideoObject)
            }else{
                print("NOOO")
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
        
    func dismissMenu(){
        print("dismiss")
        
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.5, animations: {
            self.blackview?.alpha = 0
            self.mycollectionView?.frame.origin.y = (self.fullscreen?.height)!
            self.buttonview?.alpha = 0
            self.colorbutton.center.y = -40
            self.colorbutton.alpha = 0
        })
        
        
    }
        
    func addstickerView(){
        
        UIView.animate(withDuration: 0.5, animations: {
            self.blackview?.alpha = 1
        })
        
        
        
        UIView.animate(withDuration: 0.3, animations: {
            self.blackview?.alpha = 1
            self.view.bringSubview(toFront: self.mycollectionView!)
            self.mycollectionView?.frame.origin.y = (self.fullscreen?.height)! - (self.mycollectionView?.collectionViewLayout.collectionViewContentSize.height)!
        })
        
    }
    

    
    func scrollviewInit(){
        
        
        secc = UIScrollView()
        secc.frame = CGRect(x: 0, y: 0, width: (fullscreen?.width)!, height: (fullscreen?.height)!)
        secc.delegate = self as? UIScrollViewDelegate
        secc.isPagingEnabled = true
        secc.contentSize = CGSize(width: (fullscreen?.width)!*7, height: (fullscreen?.height)!)
        secc.showsHorizontalScrollIndicator = false
        secc.showsVerticalScrollIndicator = false
        
        let secondscreen = CGRect(x: self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        
        let color = UIView(frame: fullscreen!)
        color.backgroundColor = UIColor.blue
        color.alpha = 0
        
        let color2 = UIView(frame: secondscreen)
        color2.layer.addSublayer(createGradient(colorTop: UIColor(red: 192.0 / 255.0, green: 38.0 / 255.0, blue: 42.0 / 255.0, alpha: 0.2).cgColor
            , colorBotton: UIColor(red: 223 / 255.0, green: 146 / 255.0, blue: 146 / 255.0, alpha: 0.13).cgColor))
        
        let color3 = UIView(frame: CGRect(x: self.view.bounds.width * 2, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        color3.backgroundColor = UIColor(red: 146 / 255.0, green: 148 / 255.0, blue: 223 / 255.0, alpha: 0.13)
        
        let color4 = UIView(frame: CGRect(x: self.view.bounds.width * 3, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        color4.layer.addSublayer(createGradient(colorTop: UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0).cgColor
            , colorBotton: UIColor(red: 113 / 255.0, green: 255 / 255.0, blue: 230 / 255.0, alpha: 0.21).cgColor))
        
        let color5 = UIView(frame: CGRect(x: self.view.bounds.width * 4, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        color5.layer.addSublayer(createGradient(colorTop: UIColor(red: 0 / 255.0, green: 85 / 255.0, blue: 89 / 255.0, alpha: 0.19).cgColor
            , colorBotton: UIColor(red: 5 / 255.0, green: 0 / 255.0, blue: 99 / 255.0, alpha: 0.21).cgColor))
        
        let color6 = UIView(frame: CGRect(x: self.view.bounds.width * 5, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        color6.backgroundColor = UIColor(red: 255 / 255.0, green: 249 / 255.0, blue: 242 / 255.0, alpha: 0.22)
        
        
        let color7 = UIView(frame: CGRect(x: self.view.bounds.width * 6, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        color7.backgroundColor = UIColor(red: 232 / 255.0, green: 140 / 255.0, blue: 184 / 255.0, alpha: 0.13)
        color7.layer.addSublayer(createGradient(colorTop: UIColor(red: 255 / 255.0, green: 228 / 255.0, blue: 252 / 255.0, alpha: 0.1).cgColor
            , colorBotton: UIColor(red: 255 / 255.0, green: 234 / 255.0, blue: 234 / 255.0, alpha: 0.36).cgColor))
        
        
        
        secc.addSubview(color)
        secc.addSubview(color2)
        secc.addSubview(color3)
        secc.addSubview(color4)
        secc.addSubview(color5)
        secc.addSubview(color6)
        secc.addSubview(color7)

        
        
        self.canvasview?.addSubview(secc)
    }
    
    func createGradient(colorTop: CGColor, colorBotton: CGColor) -> CAGradientLayer{
        let gradient = CAGradientLayer()
        gradient.colors = [colorTop, colorBotton]
        gradient.locations = [0.0 ,1.0]
        gradient.frame = fullscreen!
        
        return gradient
        
    }
    
    
    //UICollectionView
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    // 必須實作的方法：每個 cell 要顯示的內容
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            // 依據前面註冊設置的識別名稱 "Cell" 取得目前使用的 cell
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: "Cell", for: indexPath as IndexPath)
                    as! MyCollectionViewCell
            
            // 設置 cell 內容 (即自定義元件裡 增加的圖片與文字元件)
            cell.imageView.image =
                UIImage(named: "\(indexPath.item + 1).png")
            return cell
    }
    
    // 點選 cell 後執行的動作
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        print("第 \(indexPath.item + 1) 張圖片")
        self.dismissMenu()
        
        let tempimage = UIImage(named: "\(indexPath.item + 1).png")
        let stickerView = self.buttonAction(imageName: tempimage!)
    
        
        self.canvasview?.addSubview(stickerView)
        //self.view.addSubview(stickerView)
    }
    
    
    //stickerview
    
    /// gesturecontroller
    ///
    /// 1: 單點
    /// 2: 雙指單點
    /// 3: 拖曳
    /// 4: 縮放
    /// 5: 旋轉
    func buttonAction(imageName: UIImage) -> UIImageView{
        let gestureSelect = [3,4,5]
        let sticker = UIImageView(image: resizeImage(image: imageName, targetSize: CGSize(width: 100, height: 100)))
        gestureController(sender: sticker, types: gestureSelect)
        return sticker
    }
    
    
    
    func gestureController(sender: UIView, types: Array<Int>){
        
        //讓傳入的view可以被手勢影響
        sender.isUserInteractionEnabled = true
        
        for type in types {
            
            if(type == 1){
                //單指單擊
                let singleFinger =
                    UITapGestureRecognizer(target: self, action: #selector(VideoViewController.singleTap(recognizer:)))
                //singleFinger.require(toFail: doubleFingers)
                singleFinger.numberOfTapsRequired = 1
                singleFinger.numberOfTouchesRequired = 1
                sender.addGestureRecognizer(singleFinger)
            }else if(type == 2){
                //雙指單擊
                let doubleFingers =
                    UITapGestureRecognizer(target: self, action:#selector(VideoViewController.doubleTap(recognizer:)))
                doubleFingers.numberOfTapsRequired = 1
                doubleFingers.numberOfTouchesRequired = 2
                sender.addGestureRecognizer(doubleFingers)
            }else if(type == 3){
                //拖曳
                let pan = UIPanGestureRecognizer(target: self, action: #selector(VideoViewController.pan(recognizer:)))
                pan.minimumNumberOfTouches = 1
                pan.maximumNumberOfTouches = 1
                sender.addGestureRecognizer(pan)
            }else if(type == 4){
                //縮放
                let pinch = UIPinchGestureRecognizer(target: self, action: #selector(VideoViewController.pinch(recognizer:)))
                sender.addGestureRecognizer(pinch)
            }else if(type == 5){
                //旋轉
                let rotation = UIRotationGestureRecognizer(target: self, action: #selector(VideoViewController.rotation(recognizer:)))
                sender.addGestureRecognizer(rotation)
            }
        }
    }
    
    func singleTap(recognizer:UITapGestureRecognizer){
        print("單指連點一下")
        
        
        UIView.animate(withDuration: 0.5, animations: {
            self.blackview?.alpha = 1
        })
        
        
        
        // 取得每指的位置
        self.findFingersPositon(recognizer: recognizer)
    }
    
    func doubleTap(recognizer:UITapGestureRecognizer){
        print("雙指點一下")
        
        // 取得每指的位置
        self.findFingersPositon(recognizer: recognizer)
    }
    
    
    func pan(recognizer: UIPanGestureRecognizer){
        //print("拖曳中..")
        
        dismissMenu()
        


        self.deletebutton?.alpha = 0.8
        
        let point = recognizer.location(in: self.view)
        let targetView = recognizer.view
        
        targetView?.endEditing(true)
        
        self.canvasview?.bringSubview(toFront: targetView!)

        
        targetView?.center = point
        
        if(point.x > UIScreen.main.bounds.midX-30 && point.x < UIScreen.main.bounds.midX + 30 && point.y > UIScreen.main.bounds.maxY - 60){
            targetView?.alpha = 0.6
            UIView.animate(withDuration: 0.3, animations: {
                self.deletebutton?.bounds.size.width = 60
                self.deletebutton?.bounds.size.height = 60
            })
            print(point)
            if(recognizer.state == .ended){
                print("delete")
                targetView?.removeFromSuperview()
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.deletebutton?.bounds.size.width = 30
                    self.deletebutton?.bounds.size.height = 30
                    self.deletebutton?.alpha = 0

                })
            }
        }else{
            
            UIView.animate(withDuration: 0.2, animations: {
                targetView?.alpha = 1
                self.deletebutton?.bounds.size.width = 30
                self.deletebutton?.bounds.size.height = 30
            })
            if(recognizer.state == .ended){
                UIView.animate(withDuration: 0.2, animations: {
                    self.deletebutton?.alpha = 0
                })
            }
        }
    }
    
    func pinch(recognizer:UIPinchGestureRecognizer) {
        let targetView = recognizer.view
        if recognizer.state == .began {
            print("開始縮放")
        } else if recognizer.state == .changed {
            // 圖片原尺寸
            let frm = targetView?.frame
            
            // 縮放比例
            let scale = recognizer.scale
            
            // 目前圖片寬度
            let w = frm?.width
            
            // 目前圖片高度
            let h = frm?.height
            
            // 縮放比例的限制為 0.5 ~ 2 倍
            if w! * scale > 50 && w! * scale < 800 {
                print(scale)
                
                targetView?.transform = CGAffineTransform(scaleX: scale , y: scale)
            }
        } else if recognizer.state == .ended {
            print("結束縮放")
        }
        
    }
    
    func rotation(recognizer:UIRotationGestureRecognizer){
        let targetView = recognizer.view
        
        let radian = recognizer.rotation
        let angle = radian * (180 / CGFloat(M_PI))
        
        targetView?.transform = CGAffineTransform(rotationAngle: radian)
        
        print("\(angle)")
    }
    
    
    func findFingersPositon(recognizer:UITapGestureRecognizer) {
        // 取得每指的位置
        let number = recognizer.numberOfTouches
        for i in 0..<number {
            let point = recognizer.location(
                ofTouch: i, in: recognizer.view)
            print(
                "第 \(i + 1) 指的位置：\(NSStringFromCGPoint(point))")
        }
    }
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
}



