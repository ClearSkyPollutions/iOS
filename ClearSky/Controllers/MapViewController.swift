//
//  MapViewController.swift
//  ClearSky
//
//  Created by Sihem on 16/07/2018.
//  Copyright © 2018 Sihem. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
  
    let regionRadius : CLLocationDistance = 1000000
    var circle: MKCircle!
    var annotation: MKPointAnnotation!
    

    @IBOutlet weak var map: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialLocation = CLLocation(latitude: 48.188529, longitude: 5.724452399999)
        centerMapOnLocation(location: initialLocation)
        
        // Service call
        let mapService = MapService()
        mapService.getMapData { (mapData: [MapData]) in
          
            for m in mapData {
                self.drawCircleOverlay(latitude: Double(m.latitude)!, longitude: Double(m.longitude)!)
                //self.drawAnnotations(mapPoint: m)
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
        self.map.setRegion(coordinateRegion, animated: true)
    }
    
    func drawAnnotations(mapPoint : MapData) {
        let latitude = Double(mapPoint.latitude)!
        let longitude = Double(mapPoint.longitude)!
        
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation = MKPointAnnotation()
        
        annotation.title = mapPoint.system
        annotation.coordinate = coordinates
     
        var str : String = "\n"
        for p in mapPoint.pollutants {
            str += p.pollutant + ": " + p.value + " " + p.unit + "\n"
            
        }
        annotation.subtitle = str

        self.map.addAnnotation(annotation)
       
    }
    
    
   
    func drawCircleOverlay(latitude: Double, longitude: Double) {
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        circle = MKCircle(center: coordinates, radius: 5000)
        self.map.add(circle)
    }
    
    //MARK: MKMapViewDelegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.2)
        circleRenderer.strokeColor = UIColor.blue
        circleRenderer.lineWidth = 1
        
        return circleRenderer
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        //annotationView?.image = UIImage(named: "AppIcon")
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
       
        let sb = UIStoryboard.init(name: "InfoPopup", bundle: nil)
        let popup = sb.instantiateViewController(withIdentifier: "mapPopUp") as! MapPopUpViewController

        popup.systemeName = annotation.title!
        popup.systemePoluttants = annotation.subtitle!
       
        self.present(popup, animated:true)
    }
    
}

