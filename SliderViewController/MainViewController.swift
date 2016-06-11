//
//  MainViewController.swift
//  SliderViewController
//
//  Created by 辛忠翰 on 2016/6/9.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit


var dataArray = [AnyObject]()
var itemDetailArr = [itemModel]()
import MapKit
import CoreLocation

var myAnnotation = MKPointAnnotation()


class MainViewController: UIViewController, UITableViewDataSource,
    UITableViewDelegate,
    NSURLSessionDelegate,
    NSURLSessionDownloadDelegate,
    SlideMenuControllerDelegate,
    MKMapViewDelegate,
    CLLocationManagerDelegate{

    
    var itemDetailDict = [String: String]()
    var itemDetail: itemModel?
    
    var locationManager: CLLocationManager!
    
    @IBAction func leftButton(sender: UIBarButtonItem) {
    self.slideMenuController()?.openLeft()
    
    }
    
    var detailViewController: DetailViewController? = nil
    

    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: "http://data.taipei.gov.tw/opendata/apply/query/QkZCODAxNUUtQkI3My00MjU2LUIyOUEtNTNDQjk5REI0MUUw?$format=json")
        
        let sessionWtihConigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionWtihConigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let dataTask = session.downloadTaskWithURL(url!)
        dataTask.resume()
        
        
        self.setNavigationBarItem()
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
        
       
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        manager.stopUpdatingLocation()
        myAnnotation = MKPointAnnotation()
        let myLocation: CLLocationCoordinate2D? = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        myAnnotation.coordinate = myLocation!
        myAnnotation.title = "My Location!!"
        myAnnotation.subtitle = "媽！我在這裡！！"
        print(myAnnotation.coordinate)
        print("QQ")
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setNavigationBarItem(){
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
    }
    // MARK: - UITableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        //["App_Name"]: Construction unit
        cell.textLabel?.text = dataArray[indexPath.row]["App_Name"] as! String
        cell.detailTextLabel?.text = dataArray[indexPath.row]["addr"] as! String
        
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        
        for data in dataArray{
        itemDetailDict = data as! [String : String]
        
        itemDetail = itemModel(
            App_Name: itemDetailDict["App_Name"]!,
            C_Name: itemDetailDict["C_Name"]!,
            addr: itemDetailDict["addr"]!,
            Tc_Ma: itemDetailDict["Tc_Ma"]!,
            Tc_Tl: itemDetailDict["Tc_Tl"]!,
            X: itemDetailDict["X"]!,
            Y: itemDetailDict["Y"]!
            )
            
        itemDetailArr.append(itemDetail!)
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.performSegueWithIdentifier("mainToDetail", sender: nil)
    }
    
    
    
    // MARK: - NSURLSession
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        do{
            try dataArray = NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! [AnyObject]
            //NSJSONReadingOptions.MutableContainers指名會有很多資料
            self.tableView.reloadData()//再讓tableView重新reload data
            
            }catch {//有錯誤走這邊
            print("error!!")
        }
    }
    
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {//當json資料呈現在tableView時，常會藉由prepareForSegue傳送到下個頁面(detailViewController)
        if segue.identifier == "mainToDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let controller = segue.destinationViewController as! DetailViewController
                
                controller.detailDict = dataArray[indexPath.row] as! [String : String]
                
            }
        }
    }

    
}



