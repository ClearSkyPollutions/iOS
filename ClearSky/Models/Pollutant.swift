//
//  Pollutant.swift
//  ClearSky
//
//  Created by Sihem on 07/09/2018.
//  Copyright © 2018 Sihem. All rights reserved.
//

import Foundation

class Pollutant : Info {
   
    var source: String
   
    init(pollutant : [String: Any]) {
        self.source = pollutant["source"] as! String
        super.init(info: pollutant)
        
    }
}
