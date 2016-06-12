//
//  ViewModle.swift
//  SliderViewController
//
//  Created by 辛忠翰 on 2016/6/12.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import Foundation
import UIKit

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
