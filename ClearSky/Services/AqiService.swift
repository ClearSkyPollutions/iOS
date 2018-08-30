//
//  AqiService.swift
//  ClearSky
//
//  Created by Sihem on 30/07/2018.
//  Copyright © 2018 Sihem. All rights reserved.
//

import Foundation

class AqiService {
    
    let serverURL: String = "http://192.168.2.118:4000/aqi.php"
    
    
    func getAirQualityIndex(completion: @escaping ( (AQI) -> Void )) {
      
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
                let airQualityIndex : AQI
                let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
                airQualityIndex =  AQI(json: json)
                
                DispatchQueue.main.async {
                    completion(airQualityIndex)
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
