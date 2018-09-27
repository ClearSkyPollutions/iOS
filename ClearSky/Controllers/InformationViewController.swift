//
//  InformationViewController.swift
//  ClearSky
//
//  Created by Sihem on 06/09/2018.
//  Copyright © 2018 Sihem. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var pollutantArray : [Pollutant] = []
    var sensorArray : [Sensor] = []
    
    let infoService = InfoService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load data for tableview
        self.pollutantArray = self.infoService.getPollutantsData()
        self.sensorArray = self.infoService.getSensorsData()   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return pollutantArray.count
        case 1:
            return sensorArray.count
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! TableViewCell
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            cell.title.text = pollutantArray[indexPath.row].name
            cell.desc.text = pollutantArray[indexPath.row].source
            cell.img.image = UIImage(named: pollutantArray[indexPath.row].image)
        case 1:
            cell.title.text = sensorArray[indexPath.row].name
            cell.desc.text = sensorArray[indexPath.row].pollutants
            cell.img.image = UIImage(named: sensorArray[indexPath.row].image)
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let sb = UIStoryboard.init(name: "InfoPopup", bundle: nil)
        let popup = sb.instantiateInitialViewController()! as! InfoPopUpViewController
      
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                popup.info = pollutantArray[indexPath.row]
            case 1:
                popup.info = sensorArray[indexPath.row] 
            default:
                break
        }
        self.present(popup, animated:true)
        
        //Change the selected background view of the cell.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func switchTableView(_ sender: UISegmentedControl) {
        self.table.reloadData()
    }
    

}

