//
//  InfoService.swift
//  ClearSky
//
//  Created by Sihem on 11/09/2018.
//  Copyright © 2018 Sihem. All rights reserved.
//

import Foundation

class InfoService {
    
    func getPollutantsData() -> [Pollutant] {
        var array : [Pollutant] = []
        guard let path = Bundle.main.path(forResource: "pollutants", ofType: "json") else {
            return []
        }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String:Any]] {
                for p in json {
                    let pollutant = Pollutant(pollutant: p)
                    array.append(pollutant)
                }
            }
        }
        catch {
            print(error)
        }
        return array
    }
    
    func getSensorsData() -> [Sensor] {
        var array : [Sensor] = []
        guard let path = Bundle.main.path(forResource: "sensors", ofType: "json") else {
            return []
        }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String:Any]] {
                for s in json {
                    let sensor = Sensor(sensor: s)
                    array.append(sensor)
                }
            }
        }
        catch {
            print(error)
        }
        return array
    }
}
