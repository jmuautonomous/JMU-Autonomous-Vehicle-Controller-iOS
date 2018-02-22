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
    let mockApiURL = "http://134.126.153.21:8080/";
    
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
        getJsonFromUrl()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Cut Off button onClick functions
    @IBAction func cutOffButton(_ sender: UIButton) {
        cutOffAlert()
    }
    
    //this function is fetching the json from URL
    func getJsonFromUrl(){
        //creating a NSURL
        let url = NSURL(string: mockApiURL + "locations")
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                //printing the json in console
                print(jsonObj!.value(forKey: "Locations")!)
                
                //getting the avengers tag array from json and converting it to NSArray
                if let locationsArray = jsonObj!.value(forKey: "Locations") as? NSArray {
                    
                    //looping through all the elements
                    for location in locationsArray{
                        
                        //converting the element to a dictionary
                        if let locationDict = location as? NSDictionary {
                            
                            //getting the name from the dictionary
                            if let name = locationDict.value(forKey: "name") {
                                
                                //adding the name to the array
                                self.nameArray.append((name as? String)!)
                            }
                        }
                    }
                }
                
                OperationQueue.main.addOperation({
                    //calling another function after fetching the json
                    //it will show the names to label
                    self.createDynamicButtons()
                })
            }
        }).resume()
    }
    
    //function to create buttons from returned api data
    func createDynamicButtons() {
        
        var toGoButtonHeight = 64
        
        for name in nameArray{
            
            let toGoButton = UIButton(frame: CGRect(x: 0, y: toGoButtonHeight, width: 770, height: 48))
            toGoButton.setTitle(name, for: .normal)
            toGoButton.contentHorizontalAlignment = .left
            toGoButton.titleEdgeInsets.left = 20
            toGoButton.setBackgroundImage(UIImage(named: "white"), for: .normal)
            toGoButton.setBackgroundImage(UIImage(named: "highlight"), for: .selected)
            toGoButton.setTitleColor(UIColor.black, for: .normal)
            toGoButton.layer.borderColor = UIColor(displayP3Red: 0.87, green: 0.87, blue: 0.87, alpha: 1).cgColor
            toGoButton.layer.borderWidth = 1
            toGoButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            self.view.addSubview(toGoButton)
            toGoButtonHeight = toGoButtonHeight + 47
        }
    }
    @objc func buttonAction(sender: UIButton) {
        goAlert(buttonNo: 1)
    }
    
    @IBAction func addDatabaseButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let goToViewController = storyboard.instantiateViewController(withIdentifier: "GoToViewController") as UIViewController
        
        let url = NSURL(string: mockApiURL + "locations")
        
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
    
    //function that displays go to alert
    func goAlert(buttonNo: NSNumber) {
        let alert = UIAlertController(title: "Go to this destination?", message: "The vehicle will drive itself to your chosen destination", preferredStyle: .alert)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! SWRevealViewController
        
        alert.addAction(UIAlertAction(title: "Go", style: .default, handler: { (action) in
            if buttonNo == 1 {
                self.present(mapViewController, animated:true, completion:nil)
                MapViewController().mapPolylineView(buttonNo: 1)
            } else if buttonNo == 2 {
                self.present(mapViewController, animated:true, completion:nil)
                MapViewController().mapPolylineView(buttonNo: 2)
            } else if buttonNo == 3 {
                self.present(mapViewController, animated:true, completion:nil)
                MapViewController().mapPolylineView(buttonNo: 3)
            } else if buttonNo == 4 {
                self.present(mapViewController, animated:true, completion:nil)
                MapViewController().mapPolylineView(buttonNo: 4)
            }
            //alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
            //appDelegate.window?.rootViewController = goToViewController
        }))
        
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
