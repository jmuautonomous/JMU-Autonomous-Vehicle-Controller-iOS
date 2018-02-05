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
        
        //print(getDataForID(ID: "1"))
        
        //let sourceCoordinates = locationManager.location?.coordinate
        
        //loading functions
        //googleMapsTest()
        sideMenus()
        customizeNavBar()
        onLoadMapView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Cut Off button onClick functions
    @IBAction func cutOffButton1(_ sender: UIButton) {
        cutOffAlert()
    }
    @IBAction func cutOffButton2(_ sender: UIButton) {
        cutOffAlert()
    }
    @IBAction func cutOffButton3(_ sender: UIButton) {
        cutOffAlert()
    }
    
    //Go to button onClick functions
    @IBAction func goToButton1(_ sender: UIButton) {
        goAlert()
    }
    @IBAction func goToButton2(_ sender: UIButton) {
        goAlert()
    }
    @IBAction func goToButton3(_ sender: UIButton) {
        goAlert()
    }
    @IBAction func goToButton4(_ sender: UIButton) {
        goAlert()
    }
    
    /*func getSwiftArrayFromPlist(name: String)->(Array<Dictionary<String,String>>) {
        let path = Bundle.main.path(forResource: name, ofType: "plist")
        var arr : NSArray?
        arr = NSArray(contentsOfFile: path!)
        return (arr as? Array<Dictionary<String,String>>)!
    }
    
    func getDataForID(ID: String)->(Array<[String:String]>) {
        let array = getSwiftArrayFromPlist(name: "path_isat_to_lakeview")
        let namePredicate = NSPredicate(format: "ID = %@", ID)
        return [array.filter {namePredicate.evaluate(with: $0)}[0]]
    }*/
    
    //function that controls map annotations
    func onLoadMapView() {
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
        
        //controls display of directions between user location and POI
        let sourceCoordinates = locationManager.location?.coordinate
        let destCoordinates = jmuFestivalLocation
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinates!)
        let destPlacemark = MKPlacemark(coordinate: destCoordinates)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destItem = MKMapItem(placemark: destPlacemark)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceItem
        directionRequest.destination = destItem
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate(completionHandler: {
            response, error in
            guard let response = response else {
                if let error = error {
                    print("Something went wrong")
                }
                return
            }
            
            let route = response.routes[0]
            self.mapView?.add(route.polyline, level: .aboveRoads)
            
            let rekt = route.polyline.boundingMapRect
            self.mapView?.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
        })
    }
    
    //function that displays polyline between user location and POI
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(displayP3Red: 69/255, green: 0/255, blue: 132/255, alpha: 1)
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    //function that displays cut off alert
    func cutOffAlert() {
        let alert = UIAlertController(title: "Cut off vehicle power?", message: "Are you sure you wish to cut off vehicle power?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    //function that displays go to alert
    func goAlert() {
        let alert = UIAlertController(title: "Go to this destination?", message: "The vehicle will drive itself to your chosen destination", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Go", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        }
    
    func googleMapsTest() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate 38.431928,-78.875965 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 38.431928, longitude: -78.875965, zoom: 6.0)
        let gmapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = gmapView
        
        // Creates a marker in the center of the map.
        let jmuXlabsLocationMarker = GMSMarker()
        jmuXlabsLocationMarker.position = CLLocationCoordinate2D(latitude: 38.431928, longitude: -78.875965)
        jmuXlabsLocationMarker.title = "JMU X-Labs"
        jmuXlabsLocationMarker.snippet = "Lakeview Hall 1150"
        jmuXlabsLocationMarker.map = gmapView
        
        let jmuFestivalLocationMarker = GMSMarker()
        jmuXlabsLocationMarker.position = CLLocationCoordinate2D(latitude: 38.432766, longitude: -78.859402)
        jmuXlabsLocationMarker.title = "Festival"
        jmuXlabsLocationMarker.snippet = "Festival Conference Center"
        jmuXlabsLocationMarker.map = gmapView
        
        let jmuMadisonUnionLocationMarker = GMSMarker()
        jmuXlabsLocationMarker.position = CLLocationCoordinate2D(latitude: 38.437708, longitude: -78.870807)
        jmuXlabsLocationMarker.title = "Madison Union"
        jmuXlabsLocationMarker.snippet = "Madison Union"
        jmuXlabsLocationMarker.map = gmapView
        
        let jmuQuadLocationMarker = GMSMarker()
        jmuXlabsLocationMarker.position = CLLocationCoordinate2D(latitude: 38.438833, longitude: -78.874412)
        jmuXlabsLocationMarker.title = "The Quad"
        jmuXlabsLocationMarker.snippet = "The Quad"
        jmuXlabsLocationMarker.map = gmapView
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
