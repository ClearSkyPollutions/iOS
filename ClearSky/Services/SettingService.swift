//
//  SettingsService.swift
//  ClearSky
//
//  Created by Sihem on 20/09/2018.
//  Copyright © 2018 Sihem. All rights reserved.
//

import Foundation

class SettingService {
    
    let serverURL: String = "http://192.168.2.118:4000/"
    
    
    func getConfig(completion: @escaping ( (Setting) -> Void )) {
        
        let getUrl = serverURL + "config.json"
        
        // set up the URL request
        guard let url = URL(string: getUrl) else {
            print("Error : cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set the session
        let session = URLSession(configuration: .default)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            // check for any errors
            guard error == nil else {
                print("error calling GET on url")
                print(error!)
                return
            }
            
            // make sure we got data
            guard let responseData = data else {
                print("Error : did not recieve data")
                return
            }
            // parse the result as JSON -> transform byte to json
            do
            {
                let settings : Setting
                let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
                settings =  Setting(json: json)
              
                DispatchQueue.main.async {
                    completion(settings)
                }
            }
            catch
            {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
        
    }
    
    func setConfig(settings : Setting) {
        
        let postUrl = serverURL + "config.php"
      
        guard let url = URL(string: postUrl) else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //Make JSON to send to send to server
        var json = [String:Any]()
        var addressJson = [String:Any]()
        
        json["frequency"] = settings.frequency
        json["isDataShared"] = settings.isDataShared
        json["sensors"] = settings.sensors
        json["latitude"] = String(settings.sensorLocatin.latitude)
        json["longitude"] = String(settings.sensorLocatin.longitude)
        
        addressJson["ip"] = settings.serverAddress.ip
        addressJson["port"] = settings.serverAddress.port
        
        json["serverAddress"] = addressJson
        print(json)
        
        do {
            // transform json to byte
            let jsonSettings = try JSONSerialization.data(withJSONObject: json, options: [])
            urlRequest.httpBody = jsonSettings
           
        } catch {
            print("Error: cannot create JSON from Settings object")
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                let settings : Setting

                let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
                settings =  Setting(json: json)
            }
            catch
            {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
}
