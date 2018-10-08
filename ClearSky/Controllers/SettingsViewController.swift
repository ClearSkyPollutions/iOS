//
//  SettingsViewController.swift
//  ClearSky
//
//  Created by Sihem on 20/09/2018.
//  Copyright © 2018 Sihem. All rights reserved.
//

import UIKit
import CoreLocation

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
   
    
    @IBOutlet weak var freqLabel: UILabel!
    @IBOutlet weak var freqSlider: UISlider!
    @IBOutlet weak var serverAddIpTextField: UITextField!
    @IBOutlet weak var serverAddPortTextField: UITextField!
    @IBOutlet weak var shareSwitch: UISwitch!
    @IBOutlet weak var sensorTable: UITableView!
    @IBOutlet weak var sensorListView: UIView!
    @IBOutlet weak var listConstraint: NSLayoutConstraint!
    
    
    var spinner = UIActivityIndicatorView()
    var sensorList : [String] = []
    var sensorLocation = Location(latitude: -1, longitude: -1)
    
    let settingService = SettingService()
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        startSpinner()

        settingService.getConfig { (settings: Setting) in
            
            self.freqLabel.text = String(settings.frequency)
            self.freqSlider.value = Float(settings.frequency)
            self.sensorList = settings.sensors
            self.serverAddIpTextField.text = settings.serverAddress.ip
            self.serverAddPortTextField.text = settings.serverAddress.port
            self.shareSwitch.isOn = settings.isDataShared
            self.sensorLocation.latitude = settings.sensorLocatin.latitude
            self.sensorLocation.longitude = settings.sensorLocatin.longitude
           
            self.sensorTable.reloadData()
            
            // make the sensors view height equals to sensors tableView height dynamicly
            self.listConstraint.constant = self.sensorTable.contentSize.height + 60.0
           
            self.stopSpinner()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        freqLabel.text = String(Int(sender.value))
    }
    
    @IBAction func shareDataSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            determineUserCurrentLocation()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sensorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sensorCell") as! TableViewCell
        cell.textLabel?.text = sensorList[indexPath.row]
       
        return cell
    }
    
    
    @IBAction func OnClickApplyButton(_ sender: Any) {
        let location = Location(latitude: self.sensorLocation.latitude, longitude: self.sensorLocation.longitude)
        let serverAddress = Address(ip: self.serverAddIpTextField.text!, port: self.serverAddPortTextField.text!)
        let settings = Setting(sensors: self.sensorList,
                               frequency: Int(freqSlider.value),
                               raspberryPiAddress: serverAddress,
                               serverAddress: serverAddress,
                               isDataShared:  self.shareSwitch.isOn,
                               sensorLocatin: location)
        settingService.setConfig(settings : settings)
    }
    
    
    // Current user location
    func determineUserCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        self.sensorLocation.latitude = userLocation.coordinate.latitude
        self.sensorLocation.longitude = userLocation.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func startSpinner() {
        spinner.center = self.view.center
        spinner.hidesWhenStopped = true
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        view.addSubview(spinner)
        
        spinner.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopSpinner() {
        spinner.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
}
