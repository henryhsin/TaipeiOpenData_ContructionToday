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
    
    var locationManager: CLLocationManager!
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        map.delegate = self
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
        for itemDetail in itemDetailArr{
            let x = Double((itemDetail.X)!)
            let y = Double((itemDetail.Y)!)
            Cal_TWD97_To_lonlat(x!, yy: y!)
            
            let location: CLLocationCoordinate2D? = CLLocationCoordinate2DMake(latitude!, longitude!)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location!
            annotation.title = "施工單位:\(itemDetail.App_Name!)"
            annotation.subtitle = "地址:\(itemDetail.addr!)"
            
            map.addAnnotation(annotation)
        }

    }
    
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.title! == "My Location!!" {
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myLocation")
            pin.pinTintColor = UIColor.blueColor()
            pin.canShowCallout = true
            pin.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
            return pin
        }
        return nil
    }
        
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if view.reuseIdentifier == "myLocation"{
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: - TWD97_To_WGS87
    private func Cal_TWD97_To_lonlat(xx: Double, yy: Double)
    {
    
    let a = 6378137.0;
    let b = 6356752.314245;
    
    let lon0 = 121 * M_PI / 180;
    let k0 = 0.9999;
    let dx: Double = 250000;
    let dy: Double = 0;
    let q = 1 - pow(b,2) / pow(a,2)
    let e = pow(q, 0.5);
    
    let x = xx - dx;
    let y = yy - dy;
    
    // Calculate the Meridional Arc
    let M = y/k0;
    
    // Calculate Footprint Latitude
    let mu = M/(a*(1.0 - pow(e, 2)/4.0 - 3 * pow(e, 4)/64.0 - 5 * pow(e, 6)/256.0));
    let e1 = (1.0 - pow((1.0 - pow(e, 2)), 0.5)) / (1.0 + pow((1.0 - pow(e, 2)), 0.5));
    
    let J1 = (3*e1/2 - 27 * pow(e1, 3)/32.0);
    let J2 = (21*pow(e1, 2)/16 - 55*pow(e1, 4)/32.0);
    let J3 = (151*pow(e1, 3)/96.0);
    let J4 = (1097*pow(e1, 4)/512.0);
    
    let QQ1 = mu + J1 * sin(2*mu)
    let QQ2 = J2 * sin(4*mu) + J3 * sin(6*mu)
    let QQ3 = J4 * sin(8*mu)

    let fp = QQ1 + QQ2 + QQ3
    
    // Calculate Latitude and Longitude
    
    let e2 = pow((e*a/b), 2);
    let C1 = pow(e2*cos(fp), 2);
    let T1 = pow(tan(fp), 2);
    let R1 = a*(1-pow(e, 2))/pow((1-pow(e, 2)*pow(sin(fp), 2)), (3.0/2.0));
    let N1 = a/pow((1-pow(e, 2)*pow(sin(fp), 2)), 0.5);
    
    let D = x/(N1*k0);
    
    // 計算緯度
    let Q1 = N1*tan(fp)/R1;
    let Q2 = (pow(D, 2)/2.0);
    let Q3 = (5 + 3*T1 + 10*C1 - 4*pow(C1, 2) - 9*e2)*pow(D, 4)/24.0;
    let Q4 = (61 + 90*T1 + 298*C1 + 45*pow(T1, 2) - 3*pow(C1, 2) - 252*e2)*pow(D, 6)/720.0;
    var lat = fp - Q1*(Q2 - Q3 + Q4);
    
    // 計算經度
    let Q5 = D;
    let Q6 = (1 + 2*T1 + C1)*pow(D, 3)/6;
    let Q7 = (5 - 2*C1 + 28*T1 - 3*pow(C1, 2) + 8*e2 + 24*pow(T1, 2))*pow(D, 5)/120.0;
    var lon = lon0 + (Q5 - Q6 + Q7)/cos(fp);
    
    lat = (lat * 180) / M_PI; //緯
    lon = (lon * 180) / M_PI; //經
    
    self.latitude = lat
    self.longitude = lon
        
    }
    
    
}


public struct mapModel {
    
    public var App_Name: String?
    public var C_Name: String?
    public var addr: String?
    public var Tc_Ma: String?
    public var Tc_Tl: String?
    
    public init(App_Name: String, C_Name: String, addr: String, Tc_Ma: String, Tc_Tl: String) {
        
        self.App_Name = App_Name
        self.C_Name = C_Name
        self.addr = addr
        self.Tc_Ma = Tc_Ma
        self.Tc_Tl = Tc_Tl
    }
}

