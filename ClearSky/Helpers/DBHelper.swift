//
//  DBHelper.swift
//  ClearSky
//
//  Created by Theo on 30/08/2018.
//  Copyright © 2018 Sihem. All rights reserved.
//

import UIKit
import CoreData

public class DBHelper{
    
    let dataService = DataService()
    let dateFormatter = DateFormatter()
    
    var dataChart : [MesureData] = []
    
    init() {
        //Date Formatter
        self.dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
    }
    
    func syncAll(){
        self.syncData(scale: "AVG_HOUR")
        self.syncData(scale: "AVG_DAY")
        self.syncData(scale: "AVG_MONTH")
        self.syncData(scale: "AVG_YEAR")
    }
    
    func syncData(scale : String) {
        self.dataService.getData(scale: scale, completion: { (chartdata: [MesureData]) in
            self.dataChart = chartdata
            self.clearDatabase(entity: scale)
            for d in self.dataChart{
                self.saveAVG(scale : scale, data: d)
            }
            //self.chartsCollection.reloadData()
        })
    }
    
    func saveAVG(scale: String, data: MesureData) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: scale, in: managedContext)!
        let db = NSManagedObject(entity: entity, insertInto: managedContext)
        
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
    
}
