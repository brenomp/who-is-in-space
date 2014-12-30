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
    class func getJsonData(tableView: UITableView, completionHandler:(jsonResult: NSDictionary) ->(Void))
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
                    //listOfAstronaut = currentAstronautList.listOfAstronautsInSpace!
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
