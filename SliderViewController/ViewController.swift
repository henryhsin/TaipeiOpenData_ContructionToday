//
//  ViewController.swift
//  SliderViewController
//
//  Created by 辛忠翰 on 2016/6/9.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit

class ViewController: SlideMenuController {

    override func awakeFromNib() {
        if let mainController = self.storyboard?.instantiateViewControllerWithIdentifier("main"){
            self.mainViewController = mainController
        }
        
        if let leftController = self.storyboard?.instantiateViewControllerWithIdentifier("left"){
            self.leftViewController = leftController
        }
        
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

