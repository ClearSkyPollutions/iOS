//
//  Setting.swift
//  ClearSky
//
//  Created by Sihem on 20/09/2018.
//  Copyright © 2018 Sihem. All rights reserved.
//

import Foundation

class Setting {
    
    var sensors: [String]
    var frequency: Int
    //var raspberryPiAddress: Address
    var serverAddress: Address
    var isDataShared: Bool
    var sensorLocatin: Location
    //var systemID: String
    //var systemName: String
    
    init(sensors: [String],
         frequency: Int,
         raspberryPiAddress: Address,
         serverAddress: Address,
         isDataShared: Bool,
         sensorLocatin: Location) {
        
        self.sensors = sensors
        self.frequency = frequency
        //self.raspberryPiAddress = raspberryPiAddress
        self.serverAddress = serverAddress
        self.isDataShared = isDataShared
        self.sensorLocatin = sensorLocatin
    }
    
    init(json: [String: Any]){
        self.sensors = json["sensors"] as! [String]
        self.frequency = json["frequency"] as! Int
        //self.raspberryPiAddress = json["date"] as! String
        self.isDataShared = json["isDataShared"] as! Bool
        self.sensorLocatin = Location(latitude: Double(json["latitude"] as! String)!, longitude: Double(json["longitude"] as! String)!)
        let address = json["serverAddress"] as! [String: Any]
        self.serverAddress = Address(ip: address["ip"] as! String, port: address["port"] as! String)
        
    }
}
