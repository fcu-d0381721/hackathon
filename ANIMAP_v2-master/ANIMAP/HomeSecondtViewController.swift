//
//  HomeSecondtViewContreller.swift
//  ANIMAP
//
//  Created by Winky_swl on 8/7/2017.
//  Copyright © 2017年 Winky_swl. All rights reserved.
//

import UIKit
import Firebase

class HomeSecondViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var imageArray = ["a0", "a1", "a3", "a4", "a5", "a6"]
    
    var ref: DatabaseReference!
    var locationList = [Video]()
    
    override func viewDidLoad() {
        ref = Database.database().reference().child("videos")
        getVideoData()
        
        let layout = UICollectionViewFlowLayout()
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        layout.sectionInset = UIEdgeInsetsMake(4, 4, 4, 4);
        
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        
        collectionView.collectionViewLayout = layout
    }
    
    func getVideoData(){
        
        //observing the data changes
        ref.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                //clearing the list
                self.locationList.removeAll()
                
                //iterating through all the values
                for data in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    //getting values
                    let dataObject = data.value as? [String: AnyObject]
                    
                    let videoTemp = Video()
                    videoTemp.id = data.key
                    videoTemp.longitude  = Double((dataObject?["longitude"] as? String)!)
                    videoTemp.latitude = Double((dataObject?["latitude"] as? String)!)
                    videoTemp.seen = Int((dataObject?["seen"] as? String)!)
                    videoTemp.category = dataObject?["category"] as? String
                    videoTemp.subArea = dataObject?["subArea"] as? String
                    videoTemp.city = dataObject?["city"] as? String
                    videoTemp.imageurl = dataObject?["imageurl"] as? String
                    videoTemp.url = dataObject?["url"] as? String
                    videoTemp.screenurl = dataObject?["screenurl"] as? String
                    videoTemp.videouid = dataObject?["userid"] as? String

                    
//                    print(videoTemp.id ?? String())
//                    print(videoTemp.longitude ?? Double())
//                    print(videoTemp.latitude ?? Double())
//                    print(videoTemp.city ?? String())
//                    print(videoTemp.subArea ?? String())
//                    print(videoTemp.category ?? String())
//                    print(videoTemp.url)
//                    print(videoTemp.imageurl)
                    
                    self.locationList.append(videoTemp)
                    
                }
                self.collectionView.reloadData()
                print("reload")
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return locationList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell", for: indexPath) as! HomeCell
        
        cell.configureCell(with: locationList[locationList.count - indexPath.row - 1].imageurl!)
        
        cell.imageView.layer.sublayers?.removeAll()
        
        let w = Double(UIScreen.main.bounds.size.width)
        
        let color1 = UIColor(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha: 0).cgColor
        let color2 = UIColor(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha: 0).cgColor
        let color3 =  UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.7).cgColor
            
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [color1, color2, color3]
        gradientLayer.locations = [ 0.0, 0.4, 1.0]
            
        gradientLayer.frame = CGRect(x: 0.0 , y: 0.0 , width: w/2 - 5, height: Double((w/2 - 1) * 1.3))
        cell.imageView.layer.insertSublayer(gradientLayer, at: 0)
        cell.city.text = locationList[locationList.count - indexPath.row - 1].category! + " | " + locationList[locationList.count - indexPath.row - 1].city!
        
        return cell
    
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let w = Double(UIScreen.main.bounds.size.width)

        return CGSize(width: w/2 - 5, height: (w/2 - 1) * 1.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TestingViewController(videoURL: locationList[locationList.count - indexPath.row - 1].url!, id: locationList[locationList.count - indexPath.row - 1].id!, screenurl: locationList[locationList.count - indexPath.row - 1].screenurl!, videouid: locationList[locationList.count - indexPath.row - 1].videouid!)
        self.present(vc, animated: true)
        
    }
    
    
    
    
}
