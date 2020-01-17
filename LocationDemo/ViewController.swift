//
//  ViewController.swift
//  LocationDemo
//
//  Created by My Mac on 27/12/19.
//  Copyright © 2019 My Mac. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire


class ViewController: UIViewController , CLLocationManagerDelegate{
    
    var arrLogs = [String]()

    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Test....")
        //locationManager = CLLocationManager()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { // Change `2.0` to the desired number of seconds.
           // Code you want to be delayed
            self.getCurrentLocation()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        //getCurrentLocation()
        
       // _ = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {
        // Something cool
       // getCurrentLocation()
        locationManager.startUpdatingLocation()
        
    }
    
    func getCurrentLocation()
    {
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            locationManager.distanceFilter = 10
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.allowsBackgroundLocationUpdates = true
            
        }
    }

    // MARK: Location Manager Delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let locationsObj = locations.last! as CLLocation
        print("\(Date())Current location lat-long is = \(locationsObj.coordinate.latitude) \(locationsObj.coordinate.longitude)")
        showOnMap(location: locationsObj)
        
        arrLogs.append("\(locationsObj.coordinate.latitude),\(locationsObj.coordinate.longitude)")
        
       // UserDefaults.standard.set(arrLogs, forKey: "Logs")

    /*    let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        */
        //https://react-my-burger-f2d46.firebaseio.com/posts.json
        
        
        let urlString = "https://react-my-burger-f2d46.firebaseio.com/posts.json"

        Alamofire.request(urlString, method: .post, parameters: ["lat": locationsObj.coordinate.latitude,"long":locationsObj.coordinate.longitude],encoding: JSONEncoding.default, headers: nil).responseJSON {
        response in
          switch response.result {
                        case .success:
                            print(response)

                            break
                        case .failure(let error):

                            print(error)
                        }
        }
        
        
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Get Location failed")
    }

    func showOnMap(location: CLLocation )
    {
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        //mapView.setRegion(region, animated: true)
    }

}

