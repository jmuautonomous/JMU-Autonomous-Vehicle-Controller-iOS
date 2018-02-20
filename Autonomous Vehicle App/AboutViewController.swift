//
//  ViewController.swift
//  Autonomous Vehicle App
//
//  Created by Ben Gilliam, JMU '18 on 2/20/18.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem?
    @IBOutlet weak var appVersionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loading functions
        sideMenus()
        customizeNavBar()
        displayAppInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Cut Off button onClick functions
    @IBAction func cutOffButton(_ sender: UIButton) {
        cutOffAlert()
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
    
    //function to dynamically add app info
    func displayAppInfo() {
        let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        let versionAndBuildNumber = "\(appVersionString) (\(buildNumber))"
        self.appVersionLabel?.text = versionAndBuildNumber
    }
}
