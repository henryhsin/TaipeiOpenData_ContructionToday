//
//  DetalTableViewController.swift
//  SliderViewController
//
//  Created by 辛忠翰 on 2016/6/10.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

var item: itemModel?

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSURLSessionDelegate, NSURLSessionDownloadDelegate,
    MKMapViewDelegate,
    CLLocationManagerDelegate{
    
    var detailDict = [String: String]()
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func backToMain(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        
      
        
        item = itemModel(
            App_Name: detailDict["App_Name"]!,
            C_Name: detailDict["C_Name"]!,
            addr: detailDict["addr"]!,
            Tc_Ma: detailDict["Tc_Ma"]!,
            Tc_Tl: detailDict["Tc_Tl"]!,
            X: detailDict["X"]!,
            Y: detailDict["Y"]!
        )
        
        
    }
    
        
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0{
            return "施工單位"
        }else if section == 1{
            return "施工地區"
        }else if section == 2{
            return "施工地址"
        }else if section == 3{
            return "負責人"
        }else if section == 4{
            return "聯絡電話"
        }else{
            return nil
        }
        print(item!.App_Name)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        
        
        if indexPath.section == 0{
            cell.textLabel!.text = item!.App_Name
        }else if indexPath.section == 1{
            cell.textLabel!.text = item!.C_Name
        }else if indexPath.section == 2{
            cell.textLabel!.text = item!.addr
        }else if indexPath.section == 3{
            cell.textLabel!.text = item!.Tc_Ma
        }else if indexPath.section == 4{
            cell.textLabel!.text = item!.Tc_Tl
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 4{
            let thisPhoneNum:String? = item?.Tc_Tl
            let url = NSURL(string: "tel://\(thisPhoneNum!)")//便用此電話號碼做成一個url
            print(url)
            if url != nil{
            UIApplication.sharedApplication().openURL(url!)
            }
        }else if indexPath.section == 2{
           
            let x = Double((item!.X)!)
            let y = Double((item!.Y)!)
            
            let latLong = self.Cal_TWD97_To_lonlat(x!, yy: y!)
            
            let anno = MKPointAnnotation()
            let myLocation: CLLocationCoordinate2D? = CLLocationCoordinate2DMake(latLong[0], latLong[1])
            anno.coordinate = myLocation!
            let myLoactionPlacemark = MKPlacemark(coordinate: anno.coordinate, addressDictionary: nil)
            
           
            let destination = MKMapItem(placemark: myLoactionPlacemark)
            destination.name = item?.addr
            destination.openInMapsWithLaunchOptions(Dictionary(dictionaryLiteral: (MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsDirectionsModeKey)))
            
        }
    }
    
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    
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
    
    
}


public struct itemModel {
    
    public var App_Name: String?
    public var C_Name: String?
    public var addr: String?
    public var Tc_Ma: String?
    public var Tc_Tl: String?
    public var X: String?
    public var Y: String?
    
    public init(App_Name: String, C_Name: String, addr: String, Tc_Ma: String, Tc_Tl: String, X: String, Y: String) {
        
        self.App_Name = App_Name
        self.C_Name = C_Name
        self.addr = addr
        self.Tc_Ma = Tc_Ma
        self.Tc_Tl = Tc_Tl
        self.X = X
        self.Y = Y
    }
}


