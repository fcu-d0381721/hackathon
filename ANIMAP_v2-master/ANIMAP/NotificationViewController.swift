//
//  NotificationViewController.swift
//  TabBarExample
//
//  Created by Winky_swl on 4/6/2017.
//  Copyright © 2017年 Winky_swl. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class NotificationViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    var ref: DatabaseReference!
    var commentRef: DatabaseReference!
    
    
    
    var area = UIButton()
    var food = UIButton()
    var sport = UIButton()
    var life = UIButton()
    var fun = UIButton()
    var all = UIButton()
    var blackview  :UIView?
    var cates = "全部"
    
    var buttonview: UIView?
    
    @IBOutlet weak var catelabel: UILabel!
    @IBOutlet weak var mytableview: UITableView!
    
    let articleIDs = ["0","1","2","3","4","5","6"]
    
    var articlesList = [Articles]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return articlesList.count
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
//        let vc = ArticleViewController(IDs: articleIDs[indexPath.row])
//        self.present(vc, animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier :"Box") as! BoxArticleViewController
        vc.artcle = articlesList[articlesList.count - indexPath.row - 1]
        
        
        //thread issue
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
        
        

    }

    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! QuestionTableViewCell
        cell.title.text = articlesList[articlesList.count - indexPath.row - 1].title
        cell.selectionStyle = .none
        cell.cate.text = articlesList[articlesList.count - indexPath.row - 1].category
        
        var image = UIImage()
        
        switch articlesList[articlesList.count - indexPath.row - 1].category as! String {
            case "地區":
                image = UIImage(named: "a0" + ".jpeg")!
            case "交通":
                image = UIImage(named: "a1" + ".jpeg")!
            case "天氣":
                image = UIImage(named: "a2" + ".jpeg")!
            case "生活":
                image = UIImage(named: "a3" + ".jpeg")!
            case "緊急":
                image = UIImage(named: "a4" + ".jpeg")!
            default:
                image = UIImage(named: "a0" + ".jpeg")!
        }
        
        
   
        
        cell.bgimage.image = image
        cell.bgimage.contentMode = .scaleAspectFill
        cell.bgimage.layer.masksToBounds = true
        cell.bgimage.layer.cornerRadius = 10
        cell.bgimage.alpha = 0.6
        
        
        //cell.bgimage = newImgThumb
        // newImgThumb.layer.masksToBounds = false
        // newImgThumb.backgroundColor = .red
        
        
        
       // cell.cardview.addSubview(newImgThumb)
       // cell.layer.masksToBounds = true
        return cell
    }
    
    

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //Set tabBarItem image
        self.navigationController?.tabBarItem.selectedImage = UIImage(named: "NotificationClicked")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationController?.tabBarItem.image = UIImage(named: "Notification")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
    
    func OnMenuClicked(sender: UIButton!) {
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "articleeditor") as! ArticleEditorViewController
        self.present(vc, animated: true, completion: nil)
        


    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference().child("articles")
        
        let right_menu_button = UIBarButtonItem(image: UIImage(named: "addArticle")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal),
                                                style: UIBarButtonItemStyle.plain ,
                                                target: self, action: #selector(OnMenuClicked(sender:)))
        self.navigationItem.rightBarButtonItem  = right_menu_button
        
        
        let left_menu_button = UIBarButtonItem(image: UIImage(named: "sort")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal),
                                                style: UIBarButtonItemStyle.plain ,
                                                target: self, action: #selector(addcategory))
        self.navigationItem.leftBarButtonItem  = left_menu_button
        
        self.navigationItem.title = cates
        
        // Do any additional setup after loading the view, typically from a nib.
        self.mytableview.separatorStyle = .none
        self.mytableview.backgroundView?.backgroundColor = UIColor(colorLiteralRed: 255, green: 255, blue: 255, alpha: 0)
        
//        let header = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
//        header.backgroundColor = UIColor(white: 0, alpha: 0)
        //header.backgroundColor = .red
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: mytableview.frame.width, height: 30))
         let header = UIView(frame: CGRect(x: 0, y: 0, width: mytableview.frame.width, height: 15))
        footer.backgroundColor = UIColor(white: 0, alpha: 0)
        
        
        
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: header.frame.width, height: 100))
//        label.textAlignment = NSTextAlignment.center
//        label.center = header.center
//        label.text = "西屯區"
//        label.font.withSize(20)
//        label.font = UIFont.boldSystemFont(ofSize: 24)
//        header.addSubview(label)
        
//        mytableview.tableHeaderView = header
        mytableview.tableFooterView = footer
        mytableview.tableHeaderView = header
        
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor.black
        }
        
        getData()
        setbuttongroup()
    }
    
    func gpsInit(){
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        let coordinate = locationManager.location?.coordinate
        
        if (coordinate?.latitude  ?? Double()) != 0.0 {
            
            let latlng = CLLocation(latitude: (coordinate?.latitude)!,longitude: (coordinate?.longitude)!)

            let userDefaultLanguages: [Any]? = UserDefaults.standard.object(forKey: "AppleLanguages") as? [Any]
            UserDefaults.standard.set(["zh-hant"], forKey: "AppleLanguages")
            
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(latlng, completionHandler: { (placemarks, error) in
                if error == nil && (placemarks?.count)! > 0 {
                    var placeMark: CLPlacemark!
                    placeMark = placemarks?[0]
                    
                    // City
                    if let city = placeMark.addressDictionary!["City"] as? String {
                        self.navigationItem.title = city
                        
                        print("-----\(city)")
                    }
                }
                UserDefaults.standard.set(userDefaultLanguages, forKey: "AppleLanguages")
            })
            
        } else {
            self.navigationItem.title = "西屯區"
        }
        

    }
    
    
    func getData(){
        //observing the data changes
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                //clearing the list
                self.articlesList.removeAll()
                
                //iterating through all the values
                for data in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let dataObject = data.value as? [String: AnyObject]
                    
                    let articlesTemp = Articles()
                    
                    if self.cates == "全部" {
                        articlesTemp.id = data.key
                        articlesTemp.body  = dataObject?["body"] as? String
                        articlesTemp.category  = dataObject?["category"] as? String
                        articlesTemp.city  = dataObject?["city"] as? String
                        articlesTemp.like  = Int((dataObject?["like"] as? String)!)
                        articlesTemp.subArea  = dataObject?["subArea"] as? String
                        articlesTemp.time  = dataObject?["time"] as? String
                        articlesTemp.title  = dataObject?["title"] as? String
                        articlesTemp.userid = dataObject?["userid"] as? String
                        articlesTemp.userName = dataObject?["userName"] as? String
                    
                        self.commentRef = Database.database().reference().child("articles").child(articlesTemp.id!).child("comments")
                    
                        self.commentRef.observe(DataEventType.value, with: { (commentSnapshot) in
                            articlesTemp.comments.removeAll()
                        
                            for commentData in commentSnapshot.children.allObjects as! [DataSnapshot] {
                                let commentObject = commentData.value as? [String: AnyObject]
                                let commentTemp = Comments()
                                commentTemp.id = commentData.key
                                commentTemp.body = commentObject?["body"] as? String
                                commentTemp.name = commentObject?["name"] as? String
                            
                                articlesTemp.comments.append(commentTemp)
                            }
                        })
                        self.articlesList.append(articlesTemp)
                    }
                    else if self.cates == "地區" {
                        
                        if dataObject?["city"] as? String == ShareManager.sharedInstance.city {
                            articlesTemp.id = data.key
                            articlesTemp.body  = dataObject?["body"] as? String
                            articlesTemp.category  = dataObject?["category"] as? String
                            articlesTemp.city  = dataObject?["city"] as? String
                            articlesTemp.like  = Int((dataObject?["like"] as? String)!)
                            articlesTemp.subArea  = dataObject?["subArea"] as? String
                            articlesTemp.time  = dataObject?["time"] as? String
                            articlesTemp.title  = dataObject?["title"] as? String
                            articlesTemp.userid = dataObject?["userid"] as? String
                            articlesTemp.userName = dataObject?["userName"] as? String
                        
                            self.commentRef = Database.database().reference().child("articles").child(articlesTemp.id!).child("comments")
                        
                            self.commentRef.observe(DataEventType.value, with: { (commentSnapshot) in
                                articlesTemp.comments.removeAll()
                            
                                for commentData in commentSnapshot.children.allObjects as! [DataSnapshot] {
                                    let commentObject = commentData.value as? [String: AnyObject]
                                    let commentTemp = Comments()
                                    commentTemp.id = commentData.key
                                    commentTemp.body = commentObject?["body"] as? String
                                    commentTemp.name = commentObject?["name"] as? String
                                
                                    articlesTemp.comments.append(commentTemp)
                                }
                            })
                            self.articlesList.append(articlesTemp)
                        }
                    }
                    else if self.cates == dataObject?["category"] as? String {
                        
                        articlesTemp.id = data.key
                        articlesTemp.body  = dataObject?["body"] as? String
                        articlesTemp.category  = dataObject?["category"] as? String
                        articlesTemp.city  = dataObject?["city"] as? String
                        articlesTemp.like  = Int((dataObject?["like"] as? String)!)
                        articlesTemp.subArea  = dataObject?["subArea"] as? String
                        articlesTemp.time  = dataObject?["time"] as? String
                        articlesTemp.title  = dataObject?["title"] as? String
                        articlesTemp.userid = dataObject?["userid"] as? String
                        articlesTemp.userName = dataObject?["userName"] as? String
                        
                        self.commentRef = Database.database().reference().child("articles").child(articlesTemp.id!).child("comments")
                        
                        self.commentRef.observe(DataEventType.value, with: { (commentSnapshot) in
                            articlesTemp.comments.removeAll()
                            
                            for commentData in commentSnapshot.children.allObjects as! [DataSnapshot] {
                                let commentObject = commentData.value as? [String: AnyObject]
                                let commentTemp = Comments()
                                commentTemp.id = commentData.key
                                commentTemp.body = commentObject?["body"] as? String
                                commentTemp.name = commentObject?["name"] as? String
                                
                                articlesTemp.comments.append(commentTemp)
                            }
                        })
                        self.articlesList.append(articlesTemp)
                    }
                }
                
                //reloading the tableview
                self.mytableview.reloadData()
            }
        })
    }
    
    
    //分類
    func setbuttongroup(){
        

        let fullscreen = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)

        blackview = UIView(frame: fullscreen)
        blackview?.backgroundColor = UIColor(white: 0.15, alpha: 0.9)
        blackview?.alpha = 0
        
        buttonview = UIView(frame: fullscreen)
        buttonview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissblackview)))
        
        
        all = UIButton(frame: CGRect(x: (fullscreen.midX), y: 100, width: 100, height: 50))
        all.setTitle("全部", for: .normal)
        all.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        all.center.x = (fullscreen.midX)
        all.layer.cornerRadius = 5
        all.layer.borderWidth = 1
        all.layer.borderColor = UIColor.white.cgColor
        all.addTarget(self, action: #selector(buttontap(sender:)), for: .touchUpInside)

        
        
        area = UIButton(frame: CGRect(x: (fullscreen.midX), y: 180, width: 100, height: 50))
        area.setTitle("地區", for: .normal)
        area.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        area.center.x = (fullscreen.midX)
        area.layer.cornerRadius = 5
        area.layer.borderWidth = 0
        area.layer.borderColor = UIColor.white.cgColor
        area.addTarget(self, action: #selector(buttontap(sender:)), for: .touchUpInside)
        
        food = UIButton(frame: CGRect(x: (fullscreen.midX), y: 260, width: 100, height: 50))
        food.setTitle("交通", for: .normal)
        food.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        food.center.x = (fullscreen.midX)
        food.layer.cornerRadius = 5
        food.layer.borderWidth = 0
        food.layer.borderColor = UIColor.white.cgColor
        food.addTarget(self, action: #selector(buttontap(sender:)), for: .touchUpInside)
        
        
        self.sport = UIButton(frame: CGRect(x: (fullscreen.midX), y: 340, width: 100, height: 50))
        sport.setTitle("天氣", for: .normal)
        sport.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        sport.center.x = (fullscreen.midX)
        sport.layer.cornerRadius = 5
        sport.layer.borderWidth = 0
        sport.layer.borderColor = UIColor.white.cgColor
        sport.addTarget(self, action: #selector(buttontap(sender:)), for: .touchUpInside)
        
        
        self.life = UIButton(frame: CGRect(x: (fullscreen.midX), y: 420, width: 100, height: 50))
        life.setTitle("生活", for: .normal)
        life.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        life.center.x = (fullscreen.midX)
        life.layer.cornerRadius = 5
        life.layer.borderWidth = 0
        life.layer.borderColor = UIColor.white.cgColor
        life.addTarget(self, action: #selector(buttontap(sender:)), for: .touchUpInside)
        
        
        self.fun = UIButton(frame: CGRect(x: (fullscreen.midX), y: 500, width: 100, height: 50))
        fun.setTitle("緊急", for: .normal)
        fun.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        fun.center.x = (fullscreen.midX)
        fun.layer.cornerRadius = 5
        fun.layer.borderWidth = 0
        fun.layer.borderColor = UIColor.white.cgColor
        fun.addTarget(self, action: #selector(buttontap(sender:)), for: .touchUpInside)
        
        self.buttonview?.addSubview(all)
        self.buttonview?.addSubview(area)
        self.buttonview?.addSubview(food)
        self.buttonview?.addSubview(sport)
        self.buttonview?.addSubview(life)
        self.buttonview?.addSubview(fun)
        
        
        //self.buttonview?.backgroundColor = UIColor.blue
        self.buttonview?.alpha = 0
        
        //self.buttonview?.layer.shouldRasterize = true
        
        self.view.addSubview(buttonview!)
        self.view.addSubview(blackview!)
    }
    
    func addcategory(){
        
        self.view.bringSubview(toFront: buttonview!)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.blackview?.alpha = 1
            self.buttonview?.alpha = 1
        })
        
    }
    
    func buttontap(sender: Any){
        
        let button =  sender as! UIButton
        all.layer.borderWidth = 0
        area.layer.borderWidth = 0
        food.layer.borderWidth = 0
        sport.layer.borderWidth = 0
        life.layer.borderWidth = 0
        fun.layer.borderWidth = 0
        button.layer.borderWidth = 1
        
        cates = button.titleLabel?.text as! String
        print(cates)
        
        if cates == "地區" {
            gpsInit()
        } else {
            self.navigationItem.title = cates
        }
        
        getData()

        UIView.animate(withDuration: 0.5, delay: 0.2, animations: {
            self.blackview?.alpha = 0
            self.buttonview?.alpha = 0
        })
        
    }
    
    func dismissblackview(){
        UIView.animate(withDuration: 0.5, animations: {
            self.blackview?.alpha = 0
            self.buttonview?.alpha = 0
        })
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
