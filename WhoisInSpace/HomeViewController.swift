//
//  HomeViewController.swift
//  WhoisInSpace
//
//  Created by David on 1/8/15.
//  Copyright (c) 2015 David Fry. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate
{

    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var overHeadDateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let whosInSpaceApi = WhoIsInSpaceAPI()
    
    var issCurrentLat: Double?
    var issCurrentLon: Double?
    var issCurrentTime: String?
    
    var myLatitude: Double?
    var myLongitude: Double?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserverForName(self.whosInSpaceApi.kLocationDidUpdateNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (note) -> Void in
            if let userInfo = note.userInfo as? [String:Double]
            {
                if userInfo["lat"] != nil && userInfo["lon"] != nil
                {
                    var lat = userInfo["lat"]!
                    var lon = userInfo["lon"]!
                    
                    println("Users lat is: \(lat)")
                    self.myLatitude = lat
                    println("Users lon is: \(lon)")
                    self.myLongitude = lon
                    
                    // I think this network call is called 3 or more times.  Not sure how to fix it.
                    self.whosInSpaceApi.getOverHeadPass("\(lat)", longitude: "\(lon)", completionHandler: { (dateTime) -> (Void) in
                        var riseTime = self.whosInSpaceApi.dateStringFromUnixtime(dateTime[0]["risetime"]! as Int)
                        var duration = dateTime[0]["duration"]! as Int
                        self.overHeadDateLabel.text = "\(riseTime)"
                        self.durationLabel.text = "\(duration)"
                    })
                }

                
            }
            

        }
   
        
        self.whosInSpaceApi.getCurrentLoctionOfISS { (location) -> (Void) in
            self.latitudeLabel.text = self.formatDoubleString(location.latitude, precision: 4)
            self.longitudeLabel.text = self.formatDoubleString(location.longitude, precision: 4)
            

        }
        
        
//        self.whosInSpaceApi.getOverHeadPass("\(self.myLatitude)", longitude: "\(self.myLongitude)") { (dateTime) -> (Void) in
//            println(dateTime)
//        }
        
        self.whosInSpaceApi.getMyLocation { (myCords) -> (Void) in
           println(myCords.latitude)
            
            
        }

    }

    
    

    
    
//MARK: IBActions
    @IBAction func refreshButtonPressed(sender: AnyObject)
    {
    }
    
    
//MARK: Helpers
    func formatDoubleString(theDouble:Double, precision: Int) -> String
    {
        // Allows you to decide the precision of a double in a string format
        return NSString(format: "%.\(precision)f", theDouble)
    }
    

}
