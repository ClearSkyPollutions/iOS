//
//  InfoPopUpViewController.swift
//  ClearSky
//
//  Created by Theo on 03/09/2018.
//  Copyright © 2018 Sihem. All rights reserved.
//

import UIKit

class InfoPopUpViewController: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var smalldescTextView: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var info : Info?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pollutant = info as? Pollutant {
            self.subTitleLabel.text = "Source"
            self.smalldescTextView.text = pollutant.source
        }
        else if let sensor = info as? Sensor  {
            self.subTitleLabel.text = "Pollutants"
            self.smalldescTextView.text = sensor.pollutants
        }
        
        self.titleLabel.text = info?.name
        self.descLabel.text = info?.desc
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closePopup(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
