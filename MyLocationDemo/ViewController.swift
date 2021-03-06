//
//  ViewController.swift
//  MyLocationDemo
//
//  Created by William Seyler on 12/22/17.
//  Copyright © 2017 William Seyler. All rights reserved.
//

import UIKit
import CoreLocation

extension Date {
    var ticks: Double {
        return Double((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}

class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let restUrl = URL(string:"http://r90gvdju.pentaho.com:8080/iot/Lumada")
    var priorLat = 0.0
    var priorLon = 0.0
    
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

    // ---------------------------- CLLocationManagerDelegate --------------------------------
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error)");
        let errorAlert = UIAlertController(title:"Error", message:error.localizedDescription, preferredStyle:UIAlertControllerStyle.alert)
        errorAlert.show(self, sender: nil)
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            let currentLat = location.coordinate.latitude
            let currentLon =  location.coordinate.longitude
            latitudeLabel.text = "\(currentLat)"
            longitudeValue.text = "\(currentLon)"
            if (currentLat != priorLat || currentLon != priorLon) { // Don't do anything if we haven't changed locations
                let parameters : Dictionary<String, Double> = [
                    "latitude" : currentLat,
                    "longitude" : currentLon,
                    "time" : Date().ticks
                ]
                print(parameters)
                let jsonData  = try? JSONSerialization.data(withJSONObject: parameters, options:[])
                print("JSON data object is:\(jsonData!)")
                var request = URLRequest(url:restUrl!)
                request.httpMethod = "POST"
                request.httpBody = jsonData
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("\(jsonData!.count)", forHTTPHeaderField: "Content-Length")
                let session = URLSession.shared
                session.dataTask(with: request) { data, rsp, err in
                    if let data = data {
                        print( data )
                    }
                    if let rsp = rsp {
                        print(rsp)
                    }
                    if let error = err {
                        print(error.localizedDescription)
                    }
                }.resume()
            }
        }
    }
}

