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
    let colorArray: [UIColor] = [.blue,.red,.green,.purple]
    var dataChart : [Data] = []
    
    var avgHour: [NSManagedObject] = []
    
    let chartHelper = ChartHelper()
    let dateFormatter = DateFormatter()
    let dataService = DataService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Date Formatter
        self.dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        // Service call 
        let aiqService = AqiService()
        aiqService.getAirQualityIndex { (aqi: AQI) in
            self.aqiLevelLabel.text = aqi.level
            self.aqIndexLabel.text = String(aqi.index)
        }
        
        // Service DataService
        syncData(scale: "AVG_HOUR")
        syncData(scale: "AVG_DAY")
        syncData(scale: "AVG_MONTH")
        syncData(scale: "AVG_YEAR")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//
//        let managedContext = appDelegate.persistentContainer.viewContext
//
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AVG_HOUR")
//        do {
//            avgHour = try managedContext.fetch(fetchRequest)
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
    }
    
    func syncData(scale : String) {
        self.dataService.getData(scale: scale, completion: { (chartdata: [Data]) in
            self.dataChart = chartdata
            self.clearDatabase(entity: scale)
            for d in self.dataChart{
                self.saveAVG(scale : scale, data: d)
            }
            self.chartsCollection.reloadData()
        })
    }
    
    func saveAVG(scale: String, data: Data) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: scale,
                                                in: managedContext)!
        
        let db = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
        
        db.setValue(data.systemId, forKeyPath: "systemId")
        db.setValue(self.dateFormatter.date(from: data.date), forKeyPath: "date")
        db.setValue(data.value, forKeyPath: "value")
        db.setValue(data.typeId, forKeyPath: "typeId")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func dataDB(scale : String) -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate?.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: scale)
        
        var db : [NSManagedObject] = []
        do {
            db = (try managedContext?.fetch(fetchRequest))!
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return db
    }
    
    func clearDatabase(entity : String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        let coord = context?.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity )
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord?.execute(deleteRequest, with: context!)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    // Number of views
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.labelArray.count
    }
    
    // Populate views
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.label.text = labelArray[indexPath.item]
        cell.chart.clearValues()
        
        chartHelper.initChart(mChart: cell.chart, textColor: colorArray[indexPath.item])
        var entry : [Double] = []
        
        let avg = dataDB(scale: "AVG_HOUR")
        for data in avg{
            if data.value(forKey: "typeId") as! Int == (indexPath.item + 1) {
                entry.append((data.value(forKey: "value") as! Double))
            }
        }
        
        chartHelper.addEntry(mChart: cell.chart, entry: entry, lineColor: colorArray[indexPath.item], draw: false)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("On click on \(indexPath.item)")
    }
}
