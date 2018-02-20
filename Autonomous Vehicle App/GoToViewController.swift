//
//  ViewController.swift
//  Autonomous Vehicle App
//
//  Created by Ben Gilliam, JMU '18 on 2/20/18.
//

import UIKit
import MapKit
import GoogleMaps

class GoToViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem?
    
    //the json file url
    let URL_LOCATIONS = "http://educ.jmu.edu/~gilliabb/Inbox/locations.json";
    
    //A string array to save all the names
    var nameArray = [String]()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //requesting user location
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        //setting desired location accuracy
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
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
        let url = NSURL(string: URL_LOCATIONS)
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                //printing the json in console
                print(jsonObj!.value(forKey: "locations")!)
                
                //getting the avengers tag array from json and converting it to NSArray
                if let locationsArray = jsonObj!.value(forKey: "locations") as? NSArray {
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
            
            let toGoButton = UIButton(frame: CGRect(x: 0, y: toGoButtonHeight, width: 320, height: 48))
            toGoButton.setTitle(name, for: .normal)
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
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let mapViewController = storyBoard.instantiateViewController(withIdentifier: "MapViewController") as! SWRevealViewController
        self.present(mapViewController, animated:true, completion:nil)
        goAlert(buttonNo: 1)
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
        let goToViewController = storyboard.instantiateViewController(withIdentifier: "GoToViewController") as UIViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        alert.addAction(UIAlertAction(title: "Go", style: .default, handler: { (action) in
            if buttonNo == 1 {
                MapViewController().mapPolylineView(buttonNo: 1)
            } else if buttonNo == 2 {
                MapViewController().mapPolylineView(buttonNo: 2)
            } else if buttonNo == 3 {
                MapViewController().mapPolylineView(buttonNo: 3)
            } else if buttonNo == 4 {
                MapViewController().mapPolylineView(buttonNo: 4)
            }
            //alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
            appDelegate.window?.rootViewController = goToViewController
        }))
        
        self.present(alert, animated: true)
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
