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
        map.showsUserLocation = false
        map.userTrackingMode = .Follow
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
       self.addAnnotationForMapView(map)
        
        
        
        
        
    }

    // my location
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        manager.stopUpdatingLocation()
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        map.setRegion(region, animated: true)
        
        myAnnotation = MKPointAnnotation()
        let myLocation: CLLocationCoordinate2D? = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        myAnnotation.coordinate = myLocation!
        myAnnotation.title = "My Location!!"
        myAnnotation.subtitle = "媽！我在這裡！！"
        map.addAnnotation(myAnnotation)
        
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
//        print(itemDetailArr.count)
//        print("QQ")

    }
    
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.title! == "My Location!!" {
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myLocation")
            
            
            
            //pin.pinTintColor = UIColor.blueColor()
            pin.canShowCallout = true
            pin.image = UIImage(named: "ic_notifications_black_24dp"  )

            pin.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
            
            return pin
        }else{
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "another")
            pin.canShowCallout = true
            pin.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
            return pin
        }
    }
        
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if view.reuseIdentifier == "another"{
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

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 1. 還沒有詢問過用戶以獲得權限
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestAlwaysAuthorization()
        }
            // 2. 用戶不同意
        else if CLLocationManager.authorizationStatus() == .Denied {
            showAlert("Location services were previously denied.")
        }
            // 3. 用戶已經同意
        else if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
            showAlert("Goog Job!")
            locationManager.startUpdatingLocation()
        }
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
            let coordinate = CLLocationCoordinate2DMake(37.703026, -121.759735)
            let regionRadius = 300.0
            
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
    
    
    
    
    
}


