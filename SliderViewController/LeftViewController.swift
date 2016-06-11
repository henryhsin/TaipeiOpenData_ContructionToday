//
//  LeftViewController.swift
//  SliderViewController
//
//  Created by 辛忠翰 on 2016/6/9.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit

enum LeftMenu: Int {
    case main = 0
    case map
}


class LeftViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let data = ["main", "map"]
    var mainViewController: UIViewController!
    var mapViewController: UIViewController!
    var menus = ["main", "map"]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor.blackColor()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapViewController = storyboard.instantiateViewControllerWithIdentifier("map") as! MapViewController
        self.mapViewController = UINavigationController(rootViewController: mapViewController)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell1")
        
        
        cell?.layoutMargins = UIEdgeInsetsZero
        cell?.preservesSuperviewLayoutMargins = false
        cell?.textLabel?.text = data[indexPath.row]
        return cell!
    }

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 70))
        view.backgroundColor = UIColor.clearColor()
        
        let profileImageView = UIImageView(frame: CGRectMake(40, 5, 60, 60)) // Change frame size according to you ..
        profileImageView.image = UIImage(named: "Hsin") //Image set your
        view.addSubview(profileImageView)
        
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200.0
    }
    
    func changeViewController(menu: LeftMenu) {
        switch menu {
        case .main:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        case .map:
            self.slideMenuController()?.changeMainViewController(self.mapViewController, close: true)
        
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            self.changeViewController(menu)
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

}

    
    

