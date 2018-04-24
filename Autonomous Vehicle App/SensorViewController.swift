//
//  ViewController.swift
//  Autonomous Vehicle App
//
//  Created by Ben Gilliam, JMU '18 on 2/20/18.
//

import UIKit
import SystemConfiguration

class SensorViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem?
    
    @IBAction func refreshViewButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sensorViewController = storyboard.instantiateViewController(withIdentifier: "SensorViewController") as UIViewController
        
        self.present(sensorViewController, animated:false, completion:nil)
        print("view refreshed")
    }
    
    @IBOutlet weak var statusSensor_01: UILabel!
    @IBOutlet weak var statusSensor_02: UILabel!
    @IBOutlet weak var statusSensor_03: UILabel!
    @IBOutlet weak var statusSensor_04: UILabel!
    @IBOutlet weak var statusSensor_05: UILabel!
    @IBOutlet weak var statusSensor_06: UILabel!
    
    //A string array to save all the names
    var nameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loading functions
        sideMenus()
        customizeNavBar()
        getJsonFromUrl()
        scheduledTimerWithTimeInterval()
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
    @objc func getJsonFromUrl(){
        //creating a NSURL
        let url = NSURL(string: GoToViewController.ApiUrl.url + "cardata")
        
        if isInternetAvailable() == true {
            //fetching the data from the url
            URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
                
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                    
                    //printing the json in console
                    print(jsonObj!.value(forKey: "Cardata")!)
                    
                    //getting the avengers tag array from json and converting it to NSArray
                    if let sensorsArray = jsonObj!.value(forKey: "Cardata") as? NSArray {
                        //let sensorValues = sensorsArray.value(forKeyPath: "value.name") as! NSArray
                        
                        //self.statusSensor_01?.text = sensorValues[0] as? String
                        //self.statusSensor_02?.text = sensorValues[1] as? String
                        //self.statusSensor_03?.text = sensorValues[2] as? String
                        //self.statusSensor_04?.text = sensorValues[3] as? String
                        //self.statusSensor_05?.text = sensorValues[4] as? String
                        //self.statusSensor_06?.text = sensorValues[5] as? String
                    }
                    OperationQueue.main.addOperation({
                        //calling another function after fetching the json
                        //it will show the names to label
                        self.displaySensorData()
                    })
                }
            }).resume()
        } else {
            let alert = UIAlertController(title: "No Internet Connection", message: "You are not connected to the internet", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Reload", style: .default, handler: { (action) in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let sensorViewController = storyboard.instantiateViewController(withIdentifier: "SensorViewController") as UIViewController
                
                self.present(sensorViewController, animated:false, completion:nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
                
            }))
            
            self.present(alert, animated: true)
        }
    }
    
    //function to display sensor data
    func displaySensorData() {
        self.statusSensor_01?.text = "0V"
        self.statusSensor_02?.text = "38.4319133333, -78.87598"
        self.statusSensor_03?.text = "No Data Yet"
        self.statusSensor_04?.text = "No Data Yet"
        self.statusSensor_05?.text = "No Data Yet"
        self.statusSensor_06?.text = "No Data Yet"
    }
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        return (isReachable)
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
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "getJsonFromUrl" with the interval of 30 seconds
        var timer = Timer()
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.getJsonFromUrl), userInfo: nil, repeats: true)
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
