//
//  ViewController.swift
//  MyLocationDemo
//
//  Created by William Seyler on 12/22/17.
//  Copyright © 2017 William Seyler. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    struct ALocation {
        var lat :Double
        var long :Double
        
        func toDictionary() -> [String:Any] {
            return ["lat":self.lat, "long":self.long]
        }
    }
    let locationManager = CLLocationManager()
    
    // MARK: Properties
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeValue: UILabel!
    @IBOutlet weak var addressValue: UILabel!
    
    @IBAction func getLocation(_ sender: Any) {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // CLLocationManagerDelegate
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error)");
        let errorAlert = UIAlertController(title:"Error", message:error.localizedDescription, preferredStyle:UIAlertControllerStyle.alert)
        errorAlert.show(self, sender: nil)
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations: \(locations)")
        for location in locations {
            longitudeValue.text = "\(location.coordinate.longitude)"
            latitudeLabel.text = "\(location.coordinate.latitude)"
            
            let aLocation = ALocation(lat:location.coordinate.latitude, long:location.coordinate.longitude)
            let jsonData  = try? JSONSerialization.data(withJSONObject: aLocation.toDictionary(), options:[])
            if let JSONString = String(data: jsonData!, encoding: String.Encoding.utf8) {
                print(JSONString)
            }
        }
    }
    
}

