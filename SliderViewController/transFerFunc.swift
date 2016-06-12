//
//  transFerFunc.swift
//  SliderViewController
//
//  Created by 辛忠翰 on 2016/6/12.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import Foundation

protocol Transfer_TWD97_To_WGS87{
    func Cal_TWD97_To_lonlat(xx: Double, yy: Double) -> [Double]
}

extension DetailViewController: Transfer_TWD97_To_WGS87{
    func Cal_TWD97_To_lonlat(xx: Double, yy: Double) -> [Double] {
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
        
        var latLong = [Double]()
        
        latLong.append(lat)
        latLong.append(lon)
        
        return latLong
    }
}


extension MapViewController: Transfer_TWD97_To_WGS87{
    func Cal_TWD97_To_lonlat(xx: Double, yy: Double) -> [Double] {
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
        
        var latLong = [Double]()
        
        latLong.append(lat)
        latLong.append(lon)
        
        return latLong
    }
}


