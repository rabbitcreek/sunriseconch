//
//  ViewController.swift
//  sunriseconch
//
//  Created by RobertW. on 12/27/18.
//  Copyright © 2018 RobertW. All rights reserved.
//

import UIKit
import Solar
import CoreLocation
import UserNotifications
class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var latitudeMap : Double = 0.0
    var longMap: Double = 0.0
    @IBOutlet weak var sunsetView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      

}
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0{
            locationManager.stopUpdatingLocation()
            longMap = location.coordinate.longitude
            latitudeMap = location.coordinate.latitude
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    @IBAction func activateSchedule(_ sender: Any) {
        
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let myLocation = CLLocationCoordinate2D(latitude: latitudeMap , longitude: longMap)
        let someDate =  Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let solar = Solar(for: someDate!, coordinate: myLocation)
        //let dateAsString = solar?.sunrise
        let sunset = solar?.sunset
        
        
        // Step 1: Ask for permission
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
        
        // Step 2: Create the notification content
        let content = UNMutableNotificationContent()
        content.title = "Invitation"
        content.body = "Its sundset somwhere on the planet"
        content.categoryIdentifier = "INVITATION"
        // Step 3: Create the notification trigger
        
        
        let dateComponents = Calendar.current.dateComponents([.timeZone, .year, .month, .day, .hour, .minute, .second], from: sunset!)
        
        print(dateComponents)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // Step 4: Create the request
        
        //let uuidString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: "Anniversary", content: content, trigger: trigger)
        
        // Step 5: Register the request
        center.add(request) { (error) in
            // Check the error parameter and handle any errors
        }
        
        
        
        
        
        
        
    }
    
    
}
