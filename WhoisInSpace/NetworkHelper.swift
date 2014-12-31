//
//  NetworkHelper.swift
//  WhoisInSpace
//
//  Created by David on 12/30/14.
//  Copyright (c) 2014 David Fry. All rights reserved.
//

import Foundation
import UIKit

class NetworkHelper
{
    
    
    class func downloadJSONData(baseURL: String, endPoint: String,  tableView: UITableView, completionHandler:(jsonData:NSDictionary) ->(Void))
    {
        // Building the api url
        let baseURL = NSURL(string: baseURL)
        let endPointString = endPoint
        let fullApiURL = NSURL(string: endPointString, relativeToURL: baseURL)
        
        // Getting the Session and Task setup
        let session = NSURLSession.sharedSession()
        
        let task = session.downloadTaskWithURL(fullApiURL!, completionHandler: { (location, response, error) -> Void in
            if error == nil
            {
                let dataObject = NSData(contentsOfURL: location)
                let jsonDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSDictionary
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(jsonData: jsonDictionary)
                    tableView.reloadData()
                })
                
            }
        })
        
        task.resume()
    }
    
    
    
    class func getJsonData(tableView: UITableView, completionHandler:(listOfPeople: [Astronaut]) ->(Void))
    {
        let baseURL = NSURL(string: "http://api.open-notify.org/")
        let astronautEndPoint = "astros.json"
        let peopleInSpaceURL = NSURL(string: astronautEndPoint, relativeToURL: baseURL)
        
        let session = NSURLSession.sharedSession()
        let task = session.downloadTaskWithURL(peopleInSpaceURL!, completionHandler: { (location, response, error) -> Void in
            
            if error == nil
            {
                let dataObject = NSData(contentsOfURL: location)
                let peopleInSpaceDict = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSDictionary
                
                var currentAstronautList = AstronautList(peopleInSpaceDict: peopleInSpaceDict)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(listOfPeople: currentAstronautList.listOfAstronautsInSpace!)
                    tableView.reloadData()
                })
                
                
                
            }
            else
            {
                println(error)
            }
        })
        
        task.resume()
    }
    
    

}














