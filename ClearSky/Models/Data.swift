//
//  Data.swift
//  ClearSky
//
//  Created by Sihem on 27/07/2018.
//  Copyright © 2018 Sihem. All rights reserved.
//

import Foundation

class Data {
    let systemId : String
    let date : String
    let value : Double
    let typeId : Int
    
    init(json:[String: Any]) {
        self.systemId = json["systemId"] as! String
        self.date = json["date"] as! String
        self.value = Double(json["value"] as! String)!
        self.typeId = json["typeId"] as! Int
        
    }
}

class PollutionData {
    var typeId : Int = 0
    var name : String = ""
    var unit : String = ""
    var sensor : String = ""
    
    init(json:[String: Any]) {
        if let pollutionData = json["POLLUTANT"] as? [[String:Any]] {
            for d in pollutionData{
                self.typeId = d["id"] as! Int
                self.name = d["name"] as! String
                self.unit = d["unit"] as! String
                self.sensor = d["sensor"] as! String
            }
        }
        
    }

}
