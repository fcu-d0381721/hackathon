//
//  SendEventViewController.swift
//  ANIMAP
//
//  Created by winky_swl on 22/8/2018.
//  Copyright © 2018年 Winky_swl. All rights reserved.
//

import UIKit
import  Firebase
import CoreLocation
import Alamofire

class SendEventViewController: UIViewController {

    @IBOutlet weak var enterBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var bgview: UIView!
    
    @IBOutlet weak var descriptionField: UITextView!
    
    @IBOutlet weak var car: UIButton!
    @IBOutlet weak var fire: UIButton!
    @IBOutlet weak var earthquake: UIButton!
    @IBOutlet weak var flooding: UIButton!
    @IBOutlet weak var other: UIButton!
    
    @IBOutlet weak var fireDepartment: UIButton!
    @IBOutlet weak var police: UIButton!
    @IBOutlet weak var hospital: UIButton!
    
    var sendEventAction = 0
    
    var eventType = 0
    var organ = 0
    
    var city: String?
    var subArea: String?
    
    var latitude: Double?
    var longitude: Double?
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interface_init()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func interface_init(){
        police.layer.cornerRadius = 5
        police.layer.borderWidth = 1
        police.layer.borderColor = UIColor.black.cgColor
        
        car.layer.cornerRadius = 5
        car.layer.borderWidth = 1
        car.layer.borderColor = UIColor.black.cgColor
        
        self.descriptionField.layer.borderWidth = 1
        self.descriptionField.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        self.descriptionField.layer.cornerRadius = 5
        
        self.bgview.layer.cornerRadius = 5
        
        self.enterBtn.layer.cornerRadius = 5
        self.cancelBtn.layer.cornerRadius = 5
        
        initkeyboard()
    }
    
    func initkeyboard(){
        let singleFinger = UITapGestureRecognizer(
            target:self,
            action:#selector(singletap))
        self.view.addGestureRecognizer(singleFinger)
    }
    
    func singletap(){
        descriptionField.endEditing(true)
    }
    
    func bordersetting(sender: UIButton){
        sender.layer.cornerRadius = 5
        sender.layer.borderWidth = 1
        sender.layer.borderColor = UIColor.black.cgColor
    }
    
    func borderhidden(sender: UIButton){
        sender.layer.borderWidth = 0
    }
    
    @IBAction func enterOnClick(_ sender: Any) {
        gpsInit()
        
//        postToFirebase()
        postData()
    }
    
    @IBAction func carOnClick(_ sender: Any) {
        bordersetting(sender: car)
        borderhidden(sender: fire)
        borderhidden(sender: earthquake)
        borderhidden(sender: flooding)
        borderhidden(sender: other)
        self.eventType = 0
    }
    
    @IBAction func fireOnClick(_ sender: Any) {
        bordersetting(sender: fire)
        borderhidden(sender: car)
        borderhidden(sender: earthquake)
        borderhidden(sender: flooding)
        borderhidden(sender: other)
        self.eventType = 1
    }
    
    @IBAction func earthquakeOnClick(_ sender: Any) {
        bordersetting(sender: earthquake)
        borderhidden(sender: fire)
        borderhidden(sender: car)
        borderhidden(sender: flooding)
        borderhidden(sender: other)
        self.eventType = 2
    }
    
    @IBAction func floodingOnClick(_ sender: Any) {
        bordersetting(sender: flooding)
        borderhidden(sender: fire)
        borderhidden(sender: earthquake)
        borderhidden(sender: car)
        borderhidden(sender: other)
        self.eventType = 3
    }
    
    @IBAction func cancelOnClick(_ sender: Any) {
        self.view.removeFromSuperview()
        ShareManager.sharedInstance.sendEventAction = 0
    }
    

    @IBAction func otherOnClick(_ sender: Any) {
        bordersetting(sender: other)
        borderhidden(sender: fire)
        borderhidden(sender: earthquake)
        borderhidden(sender: flooding)
        borderhidden(sender: car)
        self.eventType = 4
    }
    
    @IBAction func policeOnClick(_ sender: Any) {
        bordersetting(sender: police)
        borderhidden(sender: hospital)
        borderhidden(sender: fireDepartment)
        self.organ = 0
    }
    
    @IBAction func hospitalOnClick(_ sender: Any) {
        bordersetting(sender: hospital)
        borderhidden(sender: fireDepartment)
        borderhidden(sender: police)
        self.organ = 2
    }
    
    @IBAction func fireDpmOnClick(_ sender: Any) {
        bordersetting(sender: fireDepartment)
        borderhidden(sender: hospital)
        borderhidden(sender: police)
        self.organ = 1
    }
    
    func gpsInit(){
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        let coordinate = locationManager.location?.coordinate
        
        if coordinate?.longitude != 0.0{
            self.latitude = coordinate?.latitude
            self.longitude = coordinate?.longitude
            
            let latlng = CLLocation(latitude: self.latitude!, longitude: self.longitude!)
            
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
                UserDefaults.standard.set(userDefaultLanguages, forKey: "AppleLanguages")
            })
        }
    }
    
    func postData() {
        var description = descriptionField.text
        
        var user_id = ShareManager.sharedInstance.uid ?? String()
        var url =  "http://140.134.26.31/hackson/report.php?"
        url += "type=" + String(organ)
        url += "&user=" + user_id
        url += "&description=" + description!
        url += "&lat=" + String(format:"%f", latitude!)
        url += "&lng=" + String(format:"%f", longitude!)
        url += "status=0"
        
        

        
        Alamofire.request(url.urlEncoded(), method: .post).responseString { response in
            switch response.result {
                case .success(let value):
                    print(value)
                case .failure(let error):
                    print(error)
                }
        }
        
        self.view.removeFromSuperview()
        ShareManager.sharedInstance.sendEventAction = 0
    }
    
    
    func postToFirebase() {
        var description = descriptionField.text
        
        ref = Database.database().reference().child("accident")
        
        let someDate = Date()
        let timeInterval = someDate.timeIntervalSince1970
        let key = "ad\(Int(timeInterval*100000))"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let someDateTime = formatter.string(from: someDate)
        
        let event = ["id": key,
                     "user_id": ShareManager.sharedInstance.uid ?? String(),
                     "latitude": latitude,
                     "longitude": longitude,
                     "type": eventType,
                     "time": someDateTime,
                     "description" : description,
                     "process": 0
            ] as [String : Any]
        
        ref.child(key).setValue(event)
        
        self.view.removeFromSuperview()
        ShareManager.sharedInstance.sendEventAction = 0
    }
}

extension String {
    
    //将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    //将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
}
