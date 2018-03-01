//
//  ViewController.swift
//  Autonomous Vehicle App
//
//  Created by Ben Gilliam, JMU '18 on 2/20/18.
//

import UIKit
import MapKit

class GoToViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem?
    @IBOutlet var mapView: MKMapView?
    
    //the json file url
    let apiURL = "http://134.126.153.21:8080/";
    
    //A string array to save all the names
    var nameArray = [String]()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView?.delegate = self as? MKMapViewDelegate
        mapView?.showsUserLocation = true
        
        //requesting user location
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        //setting desired location accuracy
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as? CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeToRefresh))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        //loading functions
        sideMenus()
        customizeNavBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Cut Off button onClick functions
    @IBAction func cutOffButton(_ sender: UIButton) {
        cutOffAlert()
    }
    
    @IBAction func addDatabaseButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let goToViewController = storyboard.instantiateViewController(withIdentifier: "GoToViewController") as UIViewController
        
        let url = NSURL(string: apiURL + "locations")
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                //printing the json in console
                print(jsonObj!.value(forKey: "Locations")!)
                
                //getting the avengers tag array from json and converting it to NSArray
                if let locationsArray = jsonObj!.value(forKey: "Locations") as? NSArray {
                    
                    let addId = String(locationsArray.count + 1)
                    let addName = "Test Test".replacingOccurrences(of: " ", with: "_")
                    let addAddress = "Test blvd".replacingOccurrences(of: " ", with: "_")
                    let addLat = "34.348764"
                    let addLong = "-78.7654"
                    
                    let addUrl = URL(string: "http://134.126.153.21:8080/addlocation/\(addId)+\(addName)+\(addAddress)+\(addLat)+\(addLong)")
                    
                    var addRequest = URLRequest(url: addUrl!)
                    addRequest.httpMethod = "GET"
                    
                    let addTask = URLSession.shared.dataTask(with: addRequest) { data, response, error in
                        if error != nil {
                            //There was an error
                        } else {
                            //The HTTP request was successful
                            print(String(data: data!, encoding: .utf8)!)
                        }
                    }
                    addTask.resume()
                    
                    self.present(goToViewController, animated:false, completion:nil)
                }
            }
        }).resume()
    }
    
    //function that displays cut off alert
    func cutOffAlert() {
        let alert = UIAlertController(title: "Cut off vehicle power?", message: "Are you sure you wish to cut off vehicle power?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            //code that cuts off car's power
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @objc func swipeToRefresh(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.down {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let goToViewController = storyboard.instantiateViewController(withIdentifier: "GoToViewController") as UIViewController
            
            self.present(goToViewController, animated:false, completion:nil)
            print("view refreshed")
        }
    }
    
    //function that control side menu interaction
    func sideMenus() {
        
        if revealViewController() != nil {
            menuButton?.target = revealViewController()
            menuButton?.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    //function that customises nav bar colours for icons, background and text
    func customizeNavBar() {
        //bar icon colour
        navigationController?.navigationBar.tintColor = UIColor.white
        
        //bar background colour
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 0/255, green: 150/255, blue: 255/255, alpha: 1)
        
        //bar text colour
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
}
