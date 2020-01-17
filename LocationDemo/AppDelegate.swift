//
//  AppDelegate.swift
//  LocationDemo
//
//  Created by My Mac on 27/12/19.
//  Copyright © 2019 My Mac. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , CLLocationManagerDelegate{

    var window : UIWindow?
   

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        sleep(5)
        BackgroundLocationManager.instance.start()
        return true
    }
    
    
    
    
}

class BackgroundLocationManager :NSObject, CLLocationManagerDelegate {

    static let instance = BackgroundLocationManager()
    static let BACKGROUND_TIMER = 10.0// restart location manager every 150 seconds
    static let UPDATE_SERVER_INTERVAL = 15.0 // 5 minutes server send

    let locationManager = CLLocationManager()
    var timer:Timer?
    var currentBgTaskId : UIBackgroundTaskIdentifier?
    var lastLocationDate : NSDate = NSDate()

    private override init(){
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.activityType = .other;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        if #available(iOS 9, *){
            locationManager.allowsBackgroundLocationUpdates = true
        }

        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    @objc func applicationEnterBackground(){
     //   FileLogger.log("applicationEnterBackground")
        start()
    }

    func start(){
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            if #available(iOS 9, *){
                locationManager.requestLocation()
            } else {
                locationManager.startUpdatingLocation()
            }
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    @objc func restart (){
        timer?.invalidate()
        timer = nil
        start()
    }

    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case CLAuthorizationStatus.restricted: break
        //log("Restricted Access to location")
        case CLAuthorizationStatus.denied: break
        //log("User denied access to location")
        case CLAuthorizationStatus.notDetermined: break
        //log("Status not determined")
        default:
            //log("startUpdatintLocation")
            if #available(iOS 9, *){
                locationManager.requestLocation()
            } else {
                locationManager.startUpdatingLocation()
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if(timer==nil){
            // The locations array is sorted in chronologically ascending order, so the
            // last element is the most recent
            guard locations.last != nil else {return}

            beginNewBackgroundTask()
            locationManager.stopUpdatingLocation()
            let now = NSDate()
            if(isItTime(now: now)){
                //TODO: Every n minutes do whatever you want with the new location. Like for example sendLocationToServer(location, now:now)

                print(Date(),"====",locations)
                
            }
        }
    }


    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      print(error)

        beginNewBackgroundTask()
        locationManager.stopUpdatingLocation()
    }

    func isItTime(now:NSDate) -> Bool {
        let timePast = now.timeIntervalSince(lastLocationDate as Date)
        let intervalExceeded = Int(timePast) > Int(BackgroundLocationManager.UPDATE_SERVER_INTERVAL)
        return intervalExceeded;
    }

    func sendLocationToServer(location:CLLocation, now:NSDate){
        //TODO
        
        print("\(Date())=== \(location)")
    }

    func beginNewBackgroundTask(){
        var previousTaskId = currentBgTaskId;
        currentBgTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: {
           // FileLogger.log("task expired: ")
        })
        if let taskId = previousTaskId{
            UIApplication.shared.endBackgroundTask(taskId)
            previousTaskId = UIBackgroundTaskIdentifier.invalid
        }

       // timer = Timer.scheduledTimer(timeInterval: BackgroundLocationManager.BACKGROUND_TIMER, target: self, selector: #selector(self.restart),userInfo: nil, repeats: false)
    }
}
