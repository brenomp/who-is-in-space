//
//  WhoIsInSpaceAPI.swift
//  WhoisInSpace
//
//  Created by David on 12/31/14.
//  Copyright (c) 2014 David Fry. All rights reserved.
//

import Foundation
import UIKit


class WhoIsInSpaceAPI
{
    var astroDictionary: NSDictionary?
    var astroList = [Astronaut]()
    
    init()
    {
        
    }
    
    func setup(tableView: UITableView)
    {
        // Does the initial setup for the app
        println("In The App Setup")
     
    }
    
//MARK:
    
    // Gets the current locations from the api and then returns a tuple
    func getCurrentLoctionOfISS(completionHandler:(location:(longitude: Double, latitude: Double, time: String)) ->(Void))
    {
        var longitude: Double?
        var latitude: Double?
        var currentTime: String?
        var currentLocation: (Double?, Double?, Int?)
        
        
        NetworkHelper.downloadJSONData("http://api.open-notify.org/", endPoint: "iss-now.json") { (jsonData) -> (Void) in
            
            var position = jsonData["iss_position"] as NSDictionary
            var unixTime = jsonData["timestamp"] as? Int
            longitude = position["longitude"] as? Double
            latitude = position["latitude"] as? Double
            currentTime = self.dateStringFromUnixtime(unixTime!)
            
            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(location: (longitude!, latitude!, currentTime!))
            })
        }
        
    }
    
    func getOverHeadPass(latitude: String, longitude: String, completionHandler:(dateTime:[NSDictionary]) ->(Void))
    {
        println("In the overHEAD pass method")
        NetworkHelper.downloadJSONData("http://api.open-notify.org/", endPoint: "iss-pass.json?lat=\(latitude)&lon=\(longitude)") { (jsonData) -> (Void) in
            var responseArray = jsonData["response"] as [NSDictionary]
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(dateTime: responseArray)
            })
        }
    }
    
    func getAstronautList(tableView: UITableView)
    {
        // Downloads the Json Data from the api on a background thread and then when the data comes backs puts it back onto the main queue
        NetworkHelper.downloadJSONData("http://api.open-notify.org/", endPoint: "astros.json") { (jsonData) -> (Void) in
            self.astroDictionary = jsonData
            //println(self.astroDictionary)
            self.astroList = self.createListOfAstronauts(jsonData)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                tableView.reloadData()
            })
        }
    }
    
    // Creates an array of Astronaut objects
    private func createListOfAstronauts(jsonDictionary: NSDictionary) -> [Astronaut]
    {
        // An array from the Json Data dicitonary
        let astronautArray = jsonDictionary["people"] as NSArray
        var astronautList: [Astronaut] = []
        
        for astronaut in astronautArray
        {
            var newAstronaut: Astronaut = Astronaut(name: astronaut["name"]! as String, craft: astronaut["craft"]! as String)
            astronautList.append(newAstronaut)
        }
        
        return astronautList
    }
    

    
//MARK: Helpers
    
    // Formats a unix time into a human readable time
    func dateStringFromUnixtime(unixTime: Int) -> String
    {
        let timeInSeconds = NSTimeInterval(unixTime)
        let date = NSDate(timeIntervalSince1970: timeInSeconds)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .MediumStyle
        
        return dateFormatter.stringFromDate(date)
    }
    
    
    
    
}