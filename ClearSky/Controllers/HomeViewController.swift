//
//  HomeViewController.swift
//  ClearSky
//
//  Created by Sihem on 16/07/2018.
//  Copyright © 2018 Sihem. All rights reserved.
//

import UIKit
import Charts
import CoreData

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
   
    @IBOutlet weak var chartsCollection: UICollectionView!
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var aqiLevelLabel: UILabel!
    @IBOutlet weak var aqIndexLabel: UILabel!
    
    let labelArray: [String] = ["PM10", "PM25", "Temperature", "Humidity"]
    var valueArray: [[Double]] = [[0,1,2],[0,1,2],[0,1,2],[0,1,2]]
    let colorArray: [UIColor] = [.blue,.red,.green,.orange]
    var dataChart : [MesureData] = []
    
    var avgHour: [NSManagedObject] = []
    let dateFormatter = DateFormatter()
    
    // Helpers
    let chartHelper = ChartHelper()
    let dbHelper = DBHelper()
    
    // Services
    let dataService = DataService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Service air quality
        let aiqService = AqiService()
        aiqService.getAirQualityIndex { (aqi: AQI) in
            self.aqiLevelLabel.text = aqi.level
            self.aqIndexLabel.text = String(aqi.index)
        }
        
        // Service Data
        self.dbHelper.syncAll()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // Number of views
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.labelArray.count
    }
    
    // Populate views
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chartCell", for: indexPath) as! CollectionViewCell
        
        cell.label.text = labelArray[indexPath.item]
        cell.chart.clearValues()
        
        chartHelper.initChart(mChart: cell.chart, textColor: colorArray[indexPath.item])
        var entry : [Double] = []
        
        let avg = self.dbHelper.dataDB(scale: "AVG_HOUR")
        for data in avg{
            if data.value(forKey: "typeId") as! Int == (indexPath.item + 1) {
                entry.append((data.value(forKey: "value") as! Double))
            }
        }
        
        chartHelper.addEntry(mChart: cell.chart, entry: entry, lineColor: colorArray[indexPath.item], draw: false)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        // show chart popup
        let chartPopUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chartPopUp") as! ChartPopUpViewController
        chartPopUp.lineChartColor = colorArray[indexPath.item]
        chartPopUp.pollutantType = labelArray[indexPath.item]
        chartPopUp.pollutantTypeId = indexPath.item + 1
        self.present(chartPopUp, animated: true)
        
    }
    
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInfoPopupSegue" {
            let infoPopup = segue.destination as! InfoPopUpViewController
            infoPopup.popupTitle = "Sihem"
        }
    }*/
}
