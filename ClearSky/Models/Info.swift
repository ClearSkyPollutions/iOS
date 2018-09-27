//
//  Info.swift
//  ClearSky
//
//  Created by Sihem on 12/09/2018.
//  Copyright © 2018 Sihem. All rights reserved.
//

import Foundation

class Info {

    let name: String
    let desc: String
    let image: String

    
    init(info : [String: Any]) {
        self.name = info["name"] as! String
        self.desc = info["desc"] as! String
        self.image = info["image"] as! String
        
    }
}
