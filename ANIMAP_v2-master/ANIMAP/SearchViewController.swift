//
//  SecondViewController.swift
//  TabBarExample
//
//  Created by Winky_swl on 2/6/2017.
//  Copyright © 2017年 Winky_swl. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import Alamofire
import SwiftyJSON

class SearchViewController: UIViewController{
    @IBOutlet weak var mkMap: MKMapView!
    
    @IBOutlet weak var filterView: UIView!
    
    @IBOutlet weak var police: UIButton!
    @IBOutlet weak var hospital: UIButton!
    @IBOutlet weak var fireDpm: UIButton!
    
    @IBOutlet weak var taipei: UIButton!
    @IBOutlet weak var hsinchu: UIButton!
    @IBOutlet weak var taoyuan: UIButton!
    @IBOutlet weak var keelung: UIButton!
    @IBOutlet weak var miaoli: UIButton!
    @IBOutlet weak var taichung: UIButton!
    @IBOutlet weak var chiayi: UIButton!
    @IBOutlet weak var changhua: UIButton!
    @IBOutlet weak var tainan: UIButton!
    @IBOutlet weak var kaohsiung: UIButton!
    @IBOutlet weak var pingtung: UIButton!
    @IBOutlet weak var yilan: UIButton!
    @IBOutlet weak var hualien: UIButton!
    @IBOutlet weak var taitung: UIButton!
    
    @IBOutlet weak var enter: UIButton!
    
    var city = "臺北"
    var dmpType = 0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //Set tabBarItem image
        self.navigationController?.tabBarItem.selectedImage = UIImage(named: "SearchClicked")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        self.navigationController?.tabBarItem.image = UIImage(named: "Search")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        taipei.layer.cornerRadius = 5
        taipei.layer.borderWidth = 1
        taipei.layer.borderColor = UIColor.white.cgColor
        
        police.layer.cornerRadius = 5
        police.layer.borderWidth = 1
        police.layer.borderColor = UIColor.white.cgColor
        
        buttonInit()
    }
    
    func bordersetting(sender: UIButton){
        sender.layer.cornerRadius = 5
        sender.layer.borderWidth = 1
        sender.layer.borderColor = UIColor.white.cgColor
    }
    
    func borderhidden(sender: UIButton){
        sender.layer.borderWidth = 0
    }
    
    func buttonInit(){
        police.addTarget(self, action: #selector(policeOnClick), for: .touchUpInside)
        hospital.addTarget(self, action: #selector(hospitalOnClick), for: .touchUpInside)
        fireDpm.addTarget(self, action: #selector(fireOnClick), for: .touchUpInside)
        
        taipei.addTarget(self, action: #selector(taipeiOnClick), for: .touchUpInside)
        hsinchu.addTarget(self, action: #selector(hsinchuOnClick), for: .touchUpInside)
        taoyuan.addTarget(self, action: #selector(taoyuanOnClick), for: .touchUpInside)
        keelung.addTarget(self, action: #selector(keelungOnClick), for: .touchUpInside)
        miaoli.addTarget(self, action: #selector(miaoliOnClick), for: .touchUpInside)
        taichung.addTarget(self, action: #selector(taichungOnClick), for: .touchUpInside)
        chiayi.addTarget(self, action: #selector(chiayiOnClick), for: .touchUpInside)
        tainan.addTarget(self, action: #selector(tainanOnClick), for: .touchUpInside)
        changhua.addTarget(self, action: #selector(changhuaOnClick), for: .touchUpInside)
        kaohsiung.addTarget(self, action: #selector(kaohsiungOnClick), for: .touchUpInside)
        pingtung.addTarget(self, action: #selector(pingtungOnClick), for: .touchUpInside)
        hualien.addTarget(self, action: #selector(hualienOnClick), for: .touchUpInside)
        yilan.addTarget(self, action: #selector(yilanOnClick), for: .touchUpInside)
        taitung.addTarget(self, action: #selector(taitungOnClick), for: .touchUpInside)
    }
    
    func policeOnClick(){
        bordersetting(sender: police)
        borderhidden(sender: fireDpm)
        borderhidden(sender: hospital)
        self.dmpType = 0
    }
    
    func hospitalOnClick(){
        bordersetting(sender: hospital)
        borderhidden(sender: police)
        borderhidden(sender: fireDpm)
        self.dmpType = 2
    }
    
    func fireOnClick(){
        bordersetting(sender: fireDpm)
        borderhidden(sender: police)
        borderhidden(sender: hospital)
        self.dmpType = 1
    }
    
    func taipeiOnClick(){
        bordersetting(sender: taipei)
        var cityArray = [
            hsinchu, taoyuan, keelung,
            miaoli, taichung, chiayi ,changhua,
            tainan, kaohsiung, pingtung, yilan,
            hualien, taitung
        ]

        for btn in cityArray{
            borderhidden(sender: btn!)
        }
        
        self.city = "臺北"
        print(city)
    }
    
    func hsinchuOnClick(){
        bordersetting(sender: hsinchu)
        var cityArray = [
            taipei, taoyuan, keelung,
            miaoli, taichung, chiayi ,changhua,
            tainan, kaohsiung, pingtung, yilan,
            hualien, taitung
        ]

        for btn in cityArray{
            borderhidden(sender: btn!)
        }
        
        self.city = "新竹"
        print(city)
    }
    
    func taoyuanOnClick(){
        bordersetting(sender: taoyuan)
        var cityArray = [
            taipei, hsinchu, keelung,
            miaoli, taichung, chiayi ,changhua,
            tainan, kaohsiung, pingtung, yilan,
            hualien, taitung
        ]

        for btn in cityArray{
            borderhidden(sender: btn!)
        }
        
        self.city = "桃園"
        print(city)
    }
    
    func keelungOnClick(){
        bordersetting(sender: keelung)
        var cityArray = [
            taipei, hsinchu, taoyuan,
            miaoli, taichung, chiayi ,changhua,
            tainan, kaohsiung, pingtung, yilan,
            hualien, taitung
        ]

        for btn in cityArray{
            borderhidden(sender: btn!)
        }
        
        self.city = "基隆"
        print(city)
    }
    
    func miaoliOnClick(){
        bordersetting(sender: miaoli)
        var cityArray = [
            taipei, hsinchu, taoyuan, keelung,
            taichung, chiayi ,changhua,
            tainan, kaohsiung, pingtung, yilan,
            hualien, taitung
        ]

        for btn in cityArray{
            borderhidden(sender: btn!)
        }
        
        self.city = "苗栗"
        print(city)
    }
    
    
    func taichungOnClick(){
        bordersetting(sender: taichung)
        var cityArray = [
            taipei, hsinchu, taoyuan, keelung,
            miaoli, chiayi ,changhua,
            tainan, kaohsiung, pingtung, yilan,
            hualien, taitung
        ]

        for btn in cityArray{
            borderhidden(sender: btn!)
        }
        
        self.city = "臺中"
        print(city)
    }
    
    func chiayiOnClick(){
        bordersetting(sender: chiayi)
        var cityArray = [
            taipei, hsinchu, taoyuan, keelung,
            miaoli, taichung, changhua,
            tainan, kaohsiung, pingtung, yilan,
            hualien, taitung
        ]

        for btn in cityArray{
            borderhidden(sender: btn!)
        }
        
        self.city = "嘉義"
        print(city)
    }
    
    func changhuaOnClick(){
        bordersetting(sender: changhua)
        var cityArray = [
            taipei, hsinchu, taoyuan, keelung,
            miaoli, taichung, chiayi ,
            tainan, kaohsiung, pingtung, yilan,
            hualien, taitung
        ]

        for btn in cityArray{
            borderhidden(sender: btn!)
        }
        
        self.city = "彰化"
        print(city)
    }
    
    func tainanOnClick(){
        bordersetting(sender: tainan)
        var cityArray = [
            taipei, hsinchu, taoyuan, keelung,
            miaoli, taichung, chiayi ,changhua,
            kaohsiung, pingtung, yilan,
            hualien, taitung
        ]

        for btn in cityArray{
            borderhidden(sender: btn!)
        }
        
        self.city = "臺南"
        print(city)
    }
    
    func kaohsiungOnClick(){
        bordersetting(sender: kaohsiung)
        var cityArray = [
            taipei, hsinchu, taoyuan, keelung,
            miaoli, taichung, chiayi ,changhua,
            tainan, pingtung, yilan,
            hualien, taitung
        ]

        for btn in cityArray{
            borderhidden(sender: btn!)
        }
        
        self.city = "高雄"
        print(city)
    }
    
    func pingtungOnClick(){
        bordersetting(sender: pingtung)
        var cityArray = [
            taipei, hsinchu, taoyuan, keelung,
            miaoli, taichung, chiayi ,changhua,
            tainan, kaohsiung, yilan,
            hualien, taitung
        ]

        for btn in cityArray{
            borderhidden(sender: btn!)
        }
        
        self.city = "屏東"
        print(city)
    }
    
    func yilanOnClick(){
        bordersetting(sender: yilan)
        var cityArray = [
            taipei, hsinchu, taoyuan, keelung,
            miaoli, taichung, chiayi ,changhua,
            tainan, kaohsiung, pingtung,
            hualien, taitung
        ]
        
        for btn in cityArray{
            borderhidden(sender: btn!)
        }
        
        self.city = "宜蘭"
        print(city)
    }
    
    func hualienOnClick(){
        bordersetting(sender: hualien)
        var cityArray = [
            taipei, hsinchu, taoyuan, keelung,
            miaoli, taichung, chiayi ,changhua,
            tainan, kaohsiung, pingtung, yilan,
            taitung
        ]

        for btn in cityArray{
            borderhidden(sender: btn!)
        }
        
        self.city = "花蓮"
        print(city)
    }
    
    func taitungOnClick(){
        bordersetting(sender: taitung)
        var cityArray = [
            taipei, hsinchu, taoyuan, keelung,
            miaoli, taichung, chiayi ,changhua,
            tainan, kaohsiung, pingtung, yilan,
            hualien
        ]

        for btn in cityArray{
            borderhidden(sender: btn!)
        }
        
        self.city = "臺東"
        print(city)
    }
    

    
    @IBAction func filterOnClick(_ sender: Any) {
        if filterView.isHidden {
            filterView.isHidden = false
        }
        else {
            filterView.isHidden = true
        }
        
    }
    @IBAction func enterOnClick(_ sender: Any) {
        getData()
    }
    
    func getData(){
        let url = "http://140.134.26.31/hackson/search.php"
        
        let data:[String:Any] = [
            "region": city,
            "type": dmpType
        ]
        
        Alamofire.request(url, method: .post, parameters: data).responseString { response in
            switch response.result {
                case .success(let value):
                    if (value == "0 results") {
                        print(0)
                    }
                    else {
                        print(value)
                    }
            
                case .failure(let error):
                    print(error)
            }

        }
    }
    
}


