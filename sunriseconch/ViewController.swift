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
class ViewController: UIViewController, CLLocationManagerDelegate, UNUserNotificationCenterDelegate{
   
    
    let locationManager = CLLocationManager()
    var latitudeMap : Double = 0.0
    var longMap: Double = 0.0
    @IBOutlet weak var sunsetView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
      

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
       
        (sender as! UIButton).setTitle("Invitation Sent", for: [])
       
        let myLocation = CLLocationCoordinate2D(latitude: latitudeMap , longitude: longMap)
        //let someDate = Date()
        let someDate =  Calendar.current.date(byAdding: .day, value: -1, to: Date())
        //someDate = someDate?.addingTimeInterval(20.0 * 60.0)
        let solar = Solar(for: someDate!, coordinate: myLocation)
        //let dateAsString = solar?.sunrise
        let sunset = solar?.sunset
        //let dateComponents = Calendar.current.dateComponents([.timeZone, .year, .month, .day, .hour, .minute, .second], from: sunset!)
        let dateComponents = Calendar.current.dateComponents([  .hour, .minute, .second], from: sunset!)
        //dateComponents.hour = 19
        //dateComponents.minute = 12
        print(" Sunset:  \(dateComponents)")
        
        let center = UNUserNotificationCenter.current()
         center.delegate = self
        let content = UNMutableNotificationContent()
        content.title = "Conch Call"
        content.body = "Its Sundown Time to Blow the Conch"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        //let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground)
        //let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        
        //center.setNotificationCategories([category])
        
        
        var dateComponents2 = DateComponents()
        dateComponents2 = Calendar.current.dateComponents([.timeZone, .year, .month, .day, .hour, .minute, .second], from: Date())
        dateComponents2.hour = dateComponents.hour
        print("This is Hour \(dateComponents2.hour!)")
        dateComponents2.minute = dateComponents.minute
        //dateComponents2.minute = 51
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "last call", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        //center.add(request)
      /*
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
        
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        // Step 4: Create the request
        
        //let uuidString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: "Anniversary", content: content, trigger: trigger)
        
        // Step 5: Register the request
        center.add(request) { (error) in
            // Check the error parameter and handle any errors
        }
       */
        let date = NSCalendar.current.date(from: dateComponents2)
        print(date!)
        let timer = Timer(fireAt: date!, interval: 0, target: self, selector: #selector(runCode), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: .common)
        
        
        
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // pull out the buried userInfo dictionary
        print("one")
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                performSegue(withIdentifier: "goToScreenTwo", sender: self)
                print("Default identifier")
                
            case "show":
                // the user tapped our "show more info…" button
                //performSegue(withIdentifier: "goToScreenTwo", sender: self)
                print("Show more information…")
                break
                
            default:
                break
            }
        }
        
        // you must call the completion handler when you're done
        completionHandler()
    }
    
    @objc func runCode(){
        print("im in runcode")
       performSegue(withIdentifier: "goToScreenTwo", sender: self)
    }
  
    
    
}
