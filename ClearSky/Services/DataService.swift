//
//  ChartService.swift
//  ClearSky
//
//  Created by Sihem on 27/07/2018.
//  Copyright © 2018 Sihem. All rights reserved.
//
// URLSession : is the key object responsible for sending and receiving HTTP requests.
//
// URLSessionDataTask: for HTTP GET requests to retrieve data from servers to memory.
// URLSessionUploadTask: to upload a file from disk to a web service, typically via a HTTP POST or PUT method.

import Foundation

class DataService {
    
    
    let serverULR: String = "http://51.38.35.251:80/AVG_HOUR?filter[]=date,gt,0&filter[]=systemId,eq,6a923685-f2ee-4b12-8373-8216c895a53e&order=date,desc&transform=1"

    func getData(scale : String, completion: @escaping ( ([Data]) -> Void )) {
        
        let rpiURL: String = "http://192.168.2.118:4000/" + scale + "?filter=date,gt,0&order=date,desc&transform=1"
        print(rpiURL)
        // set up the URL request
        guard let url = URL(string: rpiURL) else {
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
                var dataChart : [Data] = []
                
                if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String:Any]{
                    if let data = json[scale] as? [[String:Any]]{
                        for d in data{
                            let dataTemp = Data(json: d)
                            dataChart.append(dataTemp)
                        }
                    }
                }
                DispatchQueue.main.async {
                    completion(dataChart)
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
