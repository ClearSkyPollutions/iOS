//
//  PopUpViewController.swift
//  ClearSky
//
//  Created by Theo on 30/08/2018.
//  Copyright © 2018 Sihem. All rights reserved.
//

import UIKit
import Charts

class ChartPopUpViewController: UIViewController {
    
    @IBOutlet weak var scaleSegment: UISegmentedControl!
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var pollutantTypeId : Int = 0
    var lineChartColor : UIColor = .white
    var pollutantType : String = ""
    
    
    let chartHelper = ChartHelper()
    let dbHelper = DBHelper()
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = pollutantType
        drawChart(scale: "AVG_HOUR", lineColor: self.lineChartColor, pollutantTypeId: self.pollutantTypeId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func drawChart(scale: String, lineColor : UIColor, pollutantTypeId: Int ) -> Void {
        
        chartHelper.initChartDialog(mChart: self.lineChart, textColor: lineColor)
        var entry : [Double] = []
        
        let avg = self.dbHelper.dataDB(scale: scale)
        for data in avg{
            if data.value(forKey: "typeId") as! Int == pollutantTypeId {
                entry.append((data.value(forKey: "value") as! Double))
            }
        }
        chartHelper.addEntry(mChart: self.lineChart, entry: entry, lineColor: lineColor, draw: false)
    }

    
    @IBAction func sclaeSegmentTapped(_ sender: Any) {
        switch scaleSegment.selectedSegmentIndex {
        case 0:
             drawChart(scale: "AVG_HOUR", lineColor: self.lineChartColor, pollutantTypeId: self.pollutantTypeId)
        case 1:
             drawChart(scale: "AVG_DAY", lineColor: self.lineChartColor, pollutantTypeId: self.pollutantTypeId)
        case 2:
            drawChart(scale: "AVG_MONTH", lineColor: self.lineChartColor, pollutantTypeId: self.pollutantTypeId)
        default:
            break
        }
        
    }
    
    
    @IBAction func closeChartPopUp(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
