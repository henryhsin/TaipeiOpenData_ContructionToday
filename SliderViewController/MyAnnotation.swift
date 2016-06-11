//
//  MyAnnotation.swift
//  SliderViewController
//
//  Created by 辛忠翰 on 2016/6/12.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit
import MapKit

class MyAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(theCoordinate: CLLocationCoordinate2D, theTitle: String, theSubtitle: String){
        coordinate = theCoordinate
        title = theTitle
        subtitle = theSubtitle
        super.init()
    }
    
    
}
