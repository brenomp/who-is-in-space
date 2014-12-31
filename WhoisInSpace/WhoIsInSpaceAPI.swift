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
        println("In The App Setup")
        NetworkHelper.downloadJSONData("http://api.open-notify.org/", endPoint: "astros.json") { (jsonData) -> (Void) in
            self.astroDictionary = jsonData
            //println(self.astroDictionary)
            self.astroList = self.createListOfAstronauts(jsonData)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                tableView.reloadData()
            })
        }
    }
    
    private func createListOfAstronauts(jsonDictionary: NSDictionary) -> [Astronaut]
    {
        let astronautArray = jsonDictionary["people"] as NSArray
        var astronautList: [Astronaut] = []
        
        for astronaut in astronautArray
        {
            var newAstronaut: Astronaut = Astronaut(name: astronaut["name"]! as String, craft: astronaut["craft"]! as String)
            astronautList.append(newAstronaut)
        }
        
        return astronautList
    }
    
    
    func currentLoctionOfISS(completionHandler:(location:(Double, Double, Int)) ->(Void))
    {
        var longitude: Double?
        var latitude: Double?
        var time: Int?
        var currentLocation: (Double?, Double?, Int?)
        
        
        NetworkHelper.downloadJSONData("http://api.open-notify.org/", endPoint: "iss-now.json") { (jsonData) -> (Void) in
            
            var position = jsonData["iss_position"] as NSDictionary

            longitude = position["longitude"] as? Double
            latitude = position["latitude"] as? Double
            time = jsonData["timestamp"] as? Int
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(location: (longitude!, latitude!, time!))
            })
            
        }
        
        
        
        
        
    }
    
    
    
    
    
}