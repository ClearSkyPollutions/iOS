//
//  Sensor.swift
//  ClearSky
//
//  Created by Sihem on 11/09/2018.
//  Copyright © 2018 Sihem. All rights reserved.
//

import Foundation

class Sensor: Info {
 
    let pollutants: String
    
    init(sensor : [String: Any]) {
        self.pollutants = sensor["smalldesc"] as! String
        super.init(info: sensor)
    }
}
