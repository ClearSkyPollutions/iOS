//
//  MapPopUpViewController.swift
//  ClearSky
//
//  Created by Sihem on 19/09/2018.
//  Copyright © 2018 Sihem. All rights reserved.
//

import UIKit

class MapPopUpViewController : UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    
    var systemeName: String = ""
    var systemePoluttants: String = ""
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = systemeName
        self.descTextView.text = systemePoluttants
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func closePopup(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
