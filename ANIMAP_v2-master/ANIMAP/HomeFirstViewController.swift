//
//  HomeFirstViewContreller.swift
//  ANIMAP
//
//  Created by Winky_swl on 8/7/2017.
//  Copyright © 2017年 Winky_swl. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import Cluster
import CoreLocation
import SDWebImage
import AlamofireImage

class HomeFirstViewController: UIViewController{
    var ref: DatabaseReference!
    var locationList = [Video]()
    var locationManager:CLLocationManager!
    
    let annotation = Annotation()
    let clusterManager = ClusterManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        self.tabBarController?.tabBar.barTintColor = UIColor.white
        self.tabBarController?.tabBar.isTranslucent = false
        
        ref = Database.database().reference().child("videos")
        
        gpsInit()
        getVideoData()
        
        print(Auth.auth().currentUser?.uid)
        
        ShareManager.sharedInstance.uid = Auth.auth().currentUser?.uid as! String
        ShareManager.sharedInstance.name = Auth.auth().currentUser?.displayName as! String

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

                    
                    self.locationList.append(videoTemp)
                }
                
            }
            self.makeMaker()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        


        
    }
    
    func gpsInit(){
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        let coordinate = locationManager.location?.coordinate
        
        if (coordinate?.latitude  ?? Double()) != 0.0 {
            mapView.centerCoordinate = CLLocationCoordinate2D(latitude: coordinate!.latitude, longitude: coordinate!.longitude)
            ShareManager.sharedInstance.latitude = coordinate?.latitude
            ShareManager.sharedInstance.longitude = coordinate?.longitude
            
            zoomScreen(lat: (coordinate?.latitude)!, lon: (coordinate?.longitude)!)
            
            let latlng = CLLocation(latitude: (coordinate?.latitude)!,longitude: (coordinate?.longitude)!)
            
            let userDefaultLanguages: [Any]? = UserDefaults.standard.object(forKey: "AppleLanguages") as? [Any]
            UserDefaults.standard.set(["zh-hant"], forKey: "AppleLanguages")
            
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(latlng, completionHandler: { (placemarks, error) in
                if error == nil && (placemarks?.count)! > 0 {
                    var placeMark: CLPlacemark!
                    placeMark = placemarks?[0]
                    
                    ShareManager.sharedInstance.latitude = latlng.coordinate.latitude
                    ShareManager.sharedInstance.longitude = latlng.coordinate.longitude
                    
                    // City
                    if let city = placeMark.addressDictionary!["City"] as? String {
                        ShareManager.sharedInstance.city = city
                        print(city)
                    }
                    
                    if let subAdministrativeArea = placeMark.addressDictionary!["SubAdministrativeArea"] as? String {
                        ShareManager.sharedInstance.subAdministrativeArea = subAdministrativeArea
                    }
                }
                UserDefaults.standard.set(userDefaultLanguages, forKey: "AppleLanguages")
            })

            
        } else  {
//            zoomScreen(lat: 24.178693, lon: 120.64674)
//            mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 24.178693, longitude: 120.64674)
            
        }
        
    }
    
    func zoomScreen(lat: Double, lon: Double) {
        let latitude: CLLocationDegrees = 24.178693
        let longitude: CLLocationDegrees = 120.64674
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let latDeelta: CLLocationDegrees = 0.5
        let lonDeelta: CLLocationDegrees = 0.5
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDeelta, lonDeelta)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    @IBAction func zoomLocation(_ sender: Any) {
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        let coordinate = locationManager.location?.coordinate
        if (coordinate?.latitude  ?? Double()) != 0.0 {
            let zoomCoordinate = CLLocationCoordinate2D(latitude: coordinate!.latitude, longitude: coordinate!.longitude)
            let viewRegion = MKCoordinateRegionMakeWithDistance(zoomCoordinate, 800, 800)
            mapView.setRegion(viewRegion, animated: false)
        } else  {
            let zoomCoordinate = CLLocationCoordinate2D(latitude: 24.178693, longitude: 120.64674)
            let viewRegion = MKCoordinateRegionMakeWithDistance(zoomCoordinate, 800, 800)
            mapView.setRegion(viewRegion, animated: true)
        }
    }

    
    func makeMaker() {
        clusterManager.zoomLevel = 17
        var j = 0
        let locationCount = locationList.count
        clusterManager.removeAll()
        
        if locationCount != 0{
            let annotations: [Annotation] = (0..<locationCount).map { i in
                let annotation = Annotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: locationList[i].latitude!, longitude: locationList[i].longitude!)
                annotation.title = locationList[i].id
                annotation.subtitle = locationList[i].url
                annotation.imageurl = locationList[i].imageurl
                annotation.screenurl = locationList[i].screenurl
                annotation.videouid = locationList[i].videouid

                j = j + 1
                let color = UIColor.black
                if i % 2 == 0 {
                    annotation.type = .color(color, radius: 25)
                } else {
                    annotation.type = .color(color, radius: 25)
                }
                
                return annotation
            }
            clusterManager.add(annotations)
            
            locationManager = CLLocationManager()
            locationManager.requestWhenInUseAuthorization()
            let coordinate = locationManager.location?.coordinate
            
            if (coordinate?.latitude  ?? Double()) != 0.0 {
                mapView.centerCoordinate = CLLocationCoordinate2D(latitude: coordinate!.latitude, longitude: coordinate!.longitude)
            } else  {
                mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 24.178693, longitude: 120.64674)
            }
            
            
        }
    }
    
    
}

extension HomeFirstViewController: MKMapViewDelegate {
    

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let color = UIColor.red
        let a = annotation as? Annotation
        
        if let annotation = annotation as? ClusterAnnotation {
            let identifier = "cancel"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if view == nil {
                if let annotation = annotation.annotations.first as? Annotation, let type = annotation.type {
                    view = BorderedClusterAnnotationView(annotation: annotation, reuseIdentifier: identifier, type: type, borderColor: .white)
                } else {
                    view = ClusterAnnotationView(annotation: annotation, reuseIdentifier: identifier, type: .color(color, radius: 25))
                    
                }
            } else {
                view?.annotation = annotation
     
            }
            
            return view
        } else {
            let identifier = "smileload"
            
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKAnnotationView
            
            if view == nil {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)

            } else {
                view?.annotation = annotation
                
   
            }
            
            let imageview = UIImageView()
            let size = CGSize(width: 50.0, height: 50.0)
            
            let url = NSURL(string: (a?.imageurl)!)
            let placeholderImage = UIImage(named: "smileload")!
            
            imageview.sd_setImage(with: url as! URL, placeholderImage: placeholderImage)
            
            var aspectScaledToFitImage = imageview.image?.af_imageAspectScaled(toFill: size)
            aspectScaledToFitImage = aspectScaledToFitImage?.af_imageRoundedIntoCircle()
            view?.image = aspectScaledToFitImage
            view?.layer.borderColor = UIColor.white.cgColor
            view?.layer.cornerRadius = 25
            view?.layer.borderWidth = 3

            return view
        }
        
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        clusterManager.reload(mapView, visibleMapRect: mapView.visibleMapRect)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        let a  = annotation as! Annotation
        
        if let cluster = annotation as? ClusterAnnotation {
            mapView.removeAnnotations(mapView.annotations)
            var zoomRect = MKMapRectNull
            for annotation in cluster.annotations {
                let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
                let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0)
                if MKMapRectIsNull(zoomRect) {
                    zoomRect = pointRect
                } else {
                    zoomRect = MKMapRectUnion(zoomRect, pointRect)
                }
            }
            clusterManager.reload(mapView, visibleMapRect: zoomRect)
            mapView.setVisibleMapRect(zoomRect, animated: true)
        } else {
            let vc = TestingViewController(videoURL: annotation.subtitle as! String, id: annotation.title as! String,  screenurl: a.screenurl as! String, videouid: a.videouid as! String)
            self.present(vc, animated: true)
        }
    }
}

extension UIImage {
    
    func filled(with color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let mask = self.cgImage else { return self }
        context.clip(to: rect, mask: mask)
        context.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
}

class BorderedClusterAnnotationView: ClusterAnnotationView {
    var borderColor: UIColor?
    
    convenience init(annotation: MKAnnotation?, reuseIdentifier: String?, type: ClusterAnnotationType, borderColor: UIColor) {
        self.init(annotation: annotation, reuseIdentifier: reuseIdentifier, type: type)
        self.borderColor = borderColor
    }
    
    override func configure() {
        super.configure()
        
        switch type {
        case .image:
            layer.borderWidth = 0
        case .color:
            layer.borderColor = borderColor?.cgColor
            layer.borderWidth = 2
        }
    }
}

