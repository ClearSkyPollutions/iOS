//
//  AQI.swift
//  ClearSky
//
//  Created by Sihem on 30/07/2018.
//  Copyright © 2018 Sihem. All rights reserved.
//

import Foundation

class AQI {
    var index: Int
    var level: String
    var color: String
    
    init(json : [String: Any]){
        self.index = json["index"] as! Int
        self.level = json["level"] as! String
        self.color = json["color"] as! String
    }
}
