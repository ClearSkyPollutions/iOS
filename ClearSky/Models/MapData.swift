//
//  CircleOverlay.swift
//  ClearSky
//
//  Created by Sihem on 06/08/2018.
//  Copyright © 2018 Sihem. All rights reserved.
//

import Foundation

class MapData{
    let date : String
    let system : String
    let latitude : String
    let longitude : String
    var pollutants : [MapValues] = []

    init(json : [String:Any]) {
        self.date = json["date"] as! String
        self.system = json["system"] as! String
        self.latitude = json["latitude"] as! String
        self.longitude = json["longitude"] as! String
    }
    
    func getPollutants() -> [MapValues] {
        return self.pollutants
    }
}

class MapValues{
    let value : String
    let pollutant : String
    let unit : String
    let sensor : String
    
    init(json : [String:Any]) {
        self.value = json["value"] as! String
        self.pollutant = json["pollutant"] as! String
        self.unit = json["unit"] as! String
        self.sensor = json["sensor"] as! String
    }
}
