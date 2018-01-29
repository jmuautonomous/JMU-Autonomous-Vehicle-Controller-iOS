//
//  ViewController.swift
//  Autonomous Vehicle App
//
//  Created by Ben Gilliam, JMU '18 on 1/24/18.
//

import UIKit
import MapKit
import GoogleMaps

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var menuButton1: UIBarButtonItem?
    @IBOutlet weak var menuButton2: UIBarButtonItem?
    @IBOutlet weak var menuButton3: UIBarButtonItem?
    @IBOutlet var mapView: MKMapView?
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView?.delegate = self
        mapView?.showsUserLocation = true
        
        //requesting user location
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        //setting desired location accuracy
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        //let sourceCoordinates = locationManager.location?.coordinate
        
        //loading functions
        //googleMapsTest()
        sideMenus()
        customizeNavBar()
        xlabsMapView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //function that controls map
    func xlabsMapView() {
        //distanceSpan = ~map altitude
        let distanceSpan:CLLocationDegrees = 500
        
        // jmu*Location = various coordinates of JMU POIs
        let jmuXlabsLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.431928, -78.875965)
        let jmuFestivalLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.432766, -78.859402)
        let jmuMadisonUnionLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.437708, -78.870807)
        let jmuQuadLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.438833, -78.874412)
        
        //jmu*Pin = location pins that will be placed on the map
        let jmuXlabsLocationPin = MapAnnotation(title: "JMU X-Labs", subtitle: "Lakeview Hall 1150", coordinate: jmuXlabsLocation)
        let jmuFestivalLocationPin = MapAnnotation(title: "Festival", subtitle: "Festival Conference Center", coordinate: jmuFestivalLocation)
        let jmuMadisonUnionLocationPin = MapAnnotation(title: "Madison Union", subtitle: "Madison Union", coordinate: jmuMadisonUnionLocation)
        let jmuQuadLocationPin = MapAnnotation(title: "The Quad", subtitle: "The Quad", coordinate: jmuQuadLocation)
        
        //setting initial place where map will load
        mapView?.setRegion(MKCoordinateRegionMakeWithDistance(jmuXlabsLocation, distanceSpan, distanceSpan), animated: true)
        
        //adding location pins to map
        mapView?.addAnnotation(jmuXlabsLocationPin)
        mapView?.addAnnotation(jmuFestivalLocationPin)
        mapView?.addAnnotation(jmuMadisonUnionLocationPin)
        mapView?.addAnnotation(jmuQuadLocationPin)
    }
    
    func googleMapsTest() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let gmapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = gmapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = gmapView
    }
    
    //function that control side menu interaction
    func sideMenus() {
        
        if revealViewController() != nil {
            menuButton1?.target = revealViewController()
            menuButton1?.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        if revealViewController() != nil {
            menuButton2?.target = revealViewController()
            menuButton2?.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        if revealViewController() != nil {
            menuButton3?.target = revealViewController()
            menuButton3?.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    //function that customises nav bar colours for icons, background and text
    func customizeNavBar() {
        //bar icon colour
        navigationController?.navigationBar.tintColor = UIColor.white
        
        //bar background colour
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 56/255, green: 125/255, blue: 245/255, alpha: 1)
        
        //bar text colour
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }

}
