//
//  MapViewController.swift
//  ClearSky
//
//  Created by Sihem on 16/07/2018.
//  Copyright © 2018 Sihem. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    
    let regionRadius : CLLocationDistance = 1000000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let initialLocation = CLLocation(latitude: 48.188529, longitude: 5.724452399999)
        centerMapOnLocation(location: initialLocation)

        // Service call
        let mapService = MapService()
        mapService.getMapData { (mapData: [MapData]) in
          
            for m in mapData {
                  print(m.system)
                let coordinate = CLLocationCoordinate2D(latitude: Double(m.latitude)!, longitude: Double(m.longitude)!)
                let marker = MKPointAnnotation()
                let circleMarker = MKCircle(center: coordinate, radius: 200000)
                //self.mapView.add(circleMarker)
                 marker.coordinate = coordinate
                 marker.title = m.system
//                let view = MKMarkerAnnotationView(annotation: marker, reuseIdentifier: "marker")
//                view.canShowCallout = true
//                view.calloutOffset = CGPoint(x: -5, y: 5)
//
//                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                self.mapView.addAnnotation(marker)
                
           }
       }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func centerMapOnLocation(location : CLLocation) {
        // specify the rectangular region to display, to get a correct zoom level.
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

}

