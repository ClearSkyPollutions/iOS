//
//  MapService.swift
//  ClearSky
//
//  Created by Sihem on 07/08/2018.
//  Copyright © 2018 Sihem. All rights reserved.
//

import Foundation

class MapService {
    
    let serverURL: String = "http://192.168.2.118:5000/MAP?order=system,asc&transform=1"
  
    
    func getMapData (completion: @escaping ( ([MapData]) -> Void )) {
        
        // set up the URL request
        guard let url = URL(string: serverURL) else {
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
            // parse the result as JSON
            do
            {
                print("Map Data")
                var mapData : [MapData] = []
                var systemName : String = ""
                var rpi : MapData?
                
                if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String:Any] {
                    if let map = json["MAP"] as? [[String:Any]] {
                        for m in map {
                            
                            if !systemName.elementsEqual(m["system"] as! String){
                                systemName = m["system"] as! String
                                rpi = MapData(json: m)
                                mapData.append(rpi!)
                            }
                            let rpiValue = MapValues(json: m)
                            if rpi != nil{
                                rpi!.pollutants.append(rpiValue)
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    completion(mapData)
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
}
