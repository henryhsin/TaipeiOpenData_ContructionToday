//
//  MapViewController.swift
//  SliderViewController
//
//  Created by 辛忠翰 on 2016/6/11.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Foundation

var mapItem: mapModel?

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var monitoredRegions: Dictionary<String, NSDate> = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        map.delegate = self
        map.showsUserLocation = true
        map.userTrackingMode = .Follow
        
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
       self.addAnnotationForMapView(map)
        
        self.setupData()
        
        
    }

   
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestAlwaysAuthorization()
        }else if CLLocationManager.authorizationStatus() == .Denied {
            showAlert("Location services were previously denied.")
        }else if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
            showAlert("Goog Job!")
            locationManager.startUpdatingLocation()
        }
    }
    

    
    
    
    func addAnnotationForMapView(mapView: MKMapView){
        var i = 0
        for itemDetail in itemDetailArr{
            
            
            
            let x = Double((itemDetail.X)!)
            let y = Double((itemDetail.Y)!)
            let latLong = Cal_TWD97_To_lonlat(x!, yy: y!)
            latitude = latLong[0]
            longitude = latLong[1]
            itemDetailArr[i].X = String(latLong[0])
            itemDetailArr[i].Y = String(latLong[1])
            
            i = i + 1
            
            let location: CLLocationCoordinate2D? = CLLocationCoordinate2DMake(latitude!, longitude!)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location!
            annotation.title = "施工單位:\(itemDetail.App_Name!)"
            annotation.subtitle = "地址:\(itemDetail.addr!)"
            
            map.addAnnotation(annotation)
            
            
           
        }

    }
    
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier_myLocation = "MyPin"
        if annotation.isKindOfClass(MKUserLocation) {
            print("QQ")
            var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier_myLocation)
            if pin == nil{
                pin = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier_myLocation)
            }else {
                pin!.annotation = annotation
            }
            
            pin!.canShowCallout = true
            pin!.image = UIImage(named: "Ninja-48" )
            
            pin!.rightCalloutAccessoryView = UIButton(type: UIButtonType.InfoLight)
            //pin.pinTintColor = UIColor.blueColor()
            
            return pin
            
        }else if annotation.title! == "My Location!!" {
            var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier_myLocation)
            if pin == nil{
                pin = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier_myLocation)
            }else {
                pin!.annotation = annotation
            }
            
            pin!.canShowCallout = true
            pin!.image = UIImage(named: "Ninja-48" )

            pin!.rightCalloutAccessoryView = UIButton(type: UIButtonType.InfoLight)
            //pin.pinTintColor = UIColor.blueColor()

            return pin
            
            
            
            
        }else{
            var pin = mapView.dequeueReusableAnnotationViewWithIdentifier("Others")
            if pin == nil{
                pin = MKAnnotationView(annotation: annotation, reuseIdentifier: "Others")
            }else {
                pin!.annotation = annotation
            }

            pin!.canShowCallout = true
             pin!.image = UIImage(named: "Edvard Munch-48" )
            pin!.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
            return pin
        }
    }
    
        
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if view.reuseIdentifier == "Others"{
            let destLocation: CLLocationCoordinate2D? = CLLocationCoordinate2DMake(view.annotation!.coordinate.latitude, view.annotation!.coordinate.longitude)
            
            
            let myLoactionPlacemark = MKPlacemark(coordinate: view.annotation!.coordinate, addressDictionary: nil)
            
            
            let destination = MKMapItem(placemark: myLoactionPlacemark)
            
            for itemDetail in itemDetailArr{
                if itemDetail.X == String(view.annotation!.coordinate.latitude){
                    destination.name = itemDetail.addr
                }
            }
            
            
            
            destination.openInMapsWithLaunchOptions(Dictionary(dictionaryLiteral: (MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsDirectionsModeKey)))
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }

    
    func showAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    
    
    
    
    
    
    
    func setupData() {
        // 1. 檢查系統是否能夠監視 region
        if CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion.self) {
            
            // 2.準備 region 會用到的相關屬性
            let title = "Lorrenzillo's"
            let coordinate = CLLocationCoordinate2DMake(23.019999, 120.234228)
            let regionRadius = 400.0
            
            // 3. 設置 region 的相關屬性
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude,
                longitude: coordinate.longitude), radius: regionRadius, identifier: title)
            locationManager.startMonitoringForRegion(region)
            
            // 4. 創建大頭釘(annotation)
            let restaurantAnnotation = MKPointAnnotation()
            restaurantAnnotation.coordinate = coordinate;
            restaurantAnnotation.title = "\(title)";
            map.addAnnotation(restaurantAnnotation)
            
            // 5. 繪製一個圓圈圖形（用於表示 region 的範圍）
            let circle = MKCircle(centerCoordinate: coordinate, radius: regionRadius)
            map.addOverlay(circle)
        }
        else {
            print("System can't track regions")
        }
    }
    
    // 6. 繪製圓圈
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor.redColor()
        
        circleRenderer.lineWidth = 1.0
        return circleRenderer
    }
    
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        showAlert("enter \(region.identifier)")
        monitoredRegions[region.identifier] = NSDate()

    }
    
    // 2. 當用戶退出一個 region
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        showAlert("exit \(region.identifier)")
        monitoredRegions.removeValueForKey(region.identifier)

    }
    
    
    
    // 3. 更新 region
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateRegions()
    }
    
    func updateRegions() {
        
        // 1.
        let regionMaxVisiting = 10.0
        var regionsToDelete: [String] = []
        
        // 2.
        for regionIdentifier in monitoredRegions.keys {
            
            // 3.
            if NSDate().timeIntervalSinceDate(monitoredRegions[regionIdentifier]!) > regionMaxVisiting {
                showAlert("Thanks for visiting our restaurant")
                
                regionsToDelete.append(regionIdentifier)
            }
        }
        
        // 4.
        for regionIdentifier in regionsToDelete {
            monitoredRegions.removeValueForKey(regionIdentifier)
        }
    }
    
    
    
    // MARK: - Comples business logic
    
    func updateRegionsWithLocation(location: CLLocation) {
        
        let regionMaxVisiting = 1.0
        var regionsToDelete: [String] = []
        
        for regionIdentifier in monitoredRegions.keys {
            if NSDate().timeIntervalSinceDate(monitoredRegions[regionIdentifier]!) > regionMaxVisiting {
                showAlert("Thanks for visiting our restaurant")
                
                regionsToDelete.append(regionIdentifier)
            }
        }
        
        for regionIdentifier in regionsToDelete {
            monitoredRegions.removeValueForKey(regionIdentifier)
        }
    }

    
    
    
}


