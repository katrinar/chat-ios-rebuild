//
//  CTMapViewController.swift
//  chat-ios
//
//  Created by Brian Correa on 6/19/16.
//  Copyright © 2016 Velocity360. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

class CTMapViewController: CTViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var places = Array<CTPlace>()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "Map"
        self.tabBarItem.image = UIImage(named: "globe_icon.png")
    }
    
    
    override func loadView() {
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.yellowColor()
        
        self.mapView = MKMapView(frame: frame)
        view.addSubview(mapView)
        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    //MARK: - LocationManagerDelegate
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        if (status == .AuthorizedWhenInUse){
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        print("didUpdateLocations: \(locations)")
        self.locationManager.stopUpdatingLocation()
        let currentLocation = locations[0]
        
        self.mapView.centerCoordinate = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
        
        let dist = CLLocationDistance(500)
        let region = MKCoordinateRegionMakeWithDistance(self.mapView.centerCoordinate, dist, dist)
        self.mapView.setRegion(region, animated: true)
        
        //MAKE API REQUEST TO OUR BACKEND:
        
        let url = "http://localhost:3000/api/place"
        
        let params = [
            "lat": currentLocation.coordinate.latitude,
            "lng": currentLocation.coordinate.longitude
        ]
        
        
        APIManager.getRequest(url, params: params, completion: { response in
            print("\(response)")
            
            if let results = response["results"] as? Array<Dictionary<String, AnyObject>>{
                for placeInfo in results {
                    let place = CTPlace()
                    place.populate(placeInfo)
                    self.places.append(place)
                    
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.mapView.addAnnotations(self.places)
                })
            }
            
        })
        
    }
    
    //MARK: - MapViewDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let pinId = "pinId"
        if let pin = mapView.dequeueReusableAnnotationViewWithIdentifier(pinId) as? MKPinAnnotationView{
            pin.annotation = annotation
            return pin
            
        }
        
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinId)
        pin.animatesDrop = true
        pin.canShowCallout = true
        return pin
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}