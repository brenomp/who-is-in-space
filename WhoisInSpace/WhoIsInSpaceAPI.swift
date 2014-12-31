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
        NetworkHelper.downloadJSONData("http://api.open-notify.org/", endPoint: "astros.json", tableView: tableView) { (jsonData) -> (Void) in
            self.astroDictionary = jsonData
            //println(self.astroDictionary)
            self.astroList = self.createListOfAstronauts(jsonData)
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
    
    
    func currentLoctionOfISS() -> (Double, Double)
    {
//        NetworkHelper.downloadJSONData("http://api.open-notify.org/", endPoint: "iss-now.json", tableView: <#UITableView#>) { (jsonData) -> (Void) in
//            
//        }
        
        return (0.0, 0.0)
    }
    
    
    
    
    
}