//
//  ArticleEditorViewController.swift
//  ANIMAP
//
//  Created by 謝忠穎 on 2017/7/13.
//  Copyright © 2017年 Winky_swl. All rights reserved.
//

import UIKit
import  Firebase
import CoreLocation

class ArticleEditorViewController: UIViewController {
    
    @IBOutlet weak var titleedit: UITextField!
    @IBOutlet weak var bodyedit: UITextView!
    @IBOutlet weak var area: UIButton!
    @IBOutlet weak var eat: UIButton!
    @IBOutlet weak var sport: UIButton!
    @IBOutlet weak var life: UIButton!
    @IBOutlet weak var fun: UIButton!
    
    var checkisany = false
    
    let listButton = ["地區","交通","天氣","生活","緊急"]
    var choose = "地區"
    
    var totalRef: DatabaseReference!
    
    var ref: DatabaseReference!
    var latitude: Double?
    var longitude: Double?
    var city: String?
    var subArea: String?
    
    var states = ShareManager.sharedInstance.name!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gpsInit()
        
        // Do any additional setup after loading the view.
        initkeyboard()
        
        area.layer.cornerRadius = 5
        area.layer.borderWidth = 1
        area.layer.borderColor = UIColor.black.cgColor
        
        self.bodyedit.layer.borderWidth = 1
        
        self.bodyedit.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        self.bodyedit.layer.cornerRadius = 5
        
    }
    
    @IBAction func checkany(_ sender: Any) {
        let button = sender as! UIButton
        
        if(checkisany){
            checkisany = false
            button.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            states = ShareManager.sharedInstance.name!
            
        }else{
            checkisany = true
            button.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            states = "匿名"
        }
        print(states)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    func initkeyboard(){
        let singleFinger = UITapGestureRecognizer(
            target:self,
            action:#selector(singletap))
        self.view.addGestureRecognizer(singleFinger)
    }
    
    func singletap(){
        titleedit.endEditing(true)
        bodyedit.endEditing(true)
        print("TAP")
    }
    
    func bordersetting(sender: UIButton){
        sender.layer.cornerRadius = 5
        sender.layer.borderWidth = 1
        sender.layer.borderColor = UIColor.black.cgColor
    }
    
    func borderhidden(sender: UIButton){
        sender.layer.borderWidth = 0
    }
    
    
    @IBAction func area(_ sender: Any) {
        bordersetting(sender: area)
        borderhidden(sender: eat)
        borderhidden(sender: sport)
        borderhidden(sender: life)
        borderhidden(sender: fun)
        self.choose = listButton[0]
    }
    
    @IBAction func eat(_ sender: Any) {
        borderhidden(sender: area)
        bordersetting(sender: eat)
        borderhidden(sender: sport)
        borderhidden(sender: life)
        borderhidden(sender: fun)
        choose = listButton[1]
        
    }
    
    @IBAction func sport(_ sender: Any) {
        borderhidden(sender: area)
        borderhidden(sender: eat)
        bordersetting(sender: sport)
        borderhidden(sender: life)
        borderhidden(sender: fun)
        choose = listButton[2]
        
    }
    
    @IBAction func life(_ sender: Any) {
        borderhidden(sender: area)
        borderhidden(sender: eat)
        borderhidden(sender: sport)
        bordersetting(sender: life)
        borderhidden(sender: fun)
        choose = listButton[3]
        
    }
    
    @IBAction func fun(_ sender: Any) {
        borderhidden(sender: area)
        borderhidden(sender: eat)
        borderhidden(sender: sport)
        borderhidden(sender: life)
        bordersetting(sender: fun)
        choose = listButton[4]
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendArticle(_ sender: Any) {
        
        print(titleedit.text as! String)
        print(bodyedit.text)
        print(choose)
        
        self.dismiss(animated: true, completion: nil)
        insertArticle(title: titleedit.text!, body: bodyedit.text, category: choose)
    }
    
    func gpsInit(){
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        let coordinate = locationManager.location?.coordinate
        
        if coordinate?.longitude != 0.0{
            latitude = coordinate?.latitude
            longitude = coordinate?.longitude
            
            let latlng = CLLocation(latitude: latitude!, longitude: longitude!)
            
            let userDefaultLanguages: [Any]? = UserDefaults.standard.object(forKey: "AppleLanguages") as? [Any]
            UserDefaults.standard.set(["zh-hant"], forKey: "AppleLanguages")
            
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(latlng, completionHandler: { (placemarks, error) in
                if error == nil && (placemarks?.count)! > 0 {
                    var placeMark: CLPlacemark!
                    placeMark = placemarks?[0]
                    
                    // City
                    if let city = placeMark.addressDictionary!["City"] as? String {
                        self.city = city
                    }
                    
                    if let subAdministrativeArea = placeMark.addressDictionary!["SubAdministrativeArea"] as? String {
                        self.subArea = subAdministrativeArea
                    }
                }
                UserDefaults.standard.set(["zh-hant"], forKey: "AppleLanguages")
            })
        }
    }
    
    func insertArticle(title: String, body: String, category: String) {
        ref = Database.database().reference().child("articles")
        
        let someDate = Date()
        let timeInterval = someDate.timeIntervalSince1970
        let key = "a\(Int(timeInterval*100000))"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let someDateTime = formatter.string(from: someDate)
        
        let article = ["id": key,
                       "body": body,
                       "city": city ?? String(),
                       "category": choose,
                       "like": "0",
                       "subArea": subArea ?? String(),
                       "time": someDateTime,
                       "title": title,
                       "userName": states,
                       "userid": ShareManager.sharedInstance.uid ?? String()] as [String : Any]
        
        ref.child(key).setValue(article)
        
        addTotalArticle()
    }
    
    
    func addTotalArticle(){
        totalRef = Database.database().reference().child("users").child(ShareManager.sharedInstance.uid as! String).child("totalArticle")
        totalRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print(snapshot.value)
            if let totalArticle = snapshot.value as? String {
                //Do not cast print it directly may be score is Int not string
                print(totalArticle)
                var totalArticleTemp = Int(totalArticle)!
                totalArticleTemp += 1
                
                let totalArticleObject = ["totalArticle": String(totalArticleTemp)] as [String : Any]
                
                self.totalRef = Database.database().reference().child("users").child(ShareManager.sharedInstance.uid as! String)
                self.totalRef.updateChildValues(totalArticleObject)
            }else{
                print("NOOO")
            }
            
        }) { (error) in
            print(error.localizedDescription)
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
