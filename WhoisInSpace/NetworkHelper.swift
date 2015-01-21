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
    
    
    class func downloadJSONData(baseURL: String, endPoint: String, completionHandler:(jsonData:NSDictionary, networkError: Int) ->(Void))
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
                let httpResponse = response as NSHTTPURLResponse
                // Checking HTTP Response codes
                switch httpResponse.statusCode
                {
                case 200:
                    let noError = 0
                    let dataObject = NSData(contentsOfURL: location)
                    let jsonDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSDictionary
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(jsonData: jsonDictionary, networkError: noError)
                        //tableView.reloadData()
                    })
                case 400:
                    let myError = httpResponse.statusCode
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(jsonData: [:], networkError: httpResponse.statusCode)
                    })
                case 401:
                    let myError = httpResponse.statusCode
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(jsonData: [:], networkError: httpResponse.statusCode)
                    })
                case 403:
                    let myError = httpResponse.statusCode
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(jsonData: [:], networkError: httpResponse.statusCode)
                    })
                case 404:
                    let myError = httpResponse.statusCode
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(jsonData: [:], networkError: httpResponse.statusCode)
                    })
                case 500:
                    let myError = httpResponse.statusCode
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(jsonData: [:], networkError: httpResponse.statusCode)
                    })
                case 550:
                    let myError = httpResponse.statusCode
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(jsonData: [:], networkError: httpResponse.statusCode)
                    })
                default:
                    let myError = httpResponse.statusCode
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(jsonData: [:], networkError: httpResponse.statusCode)
                    })
                    
                }
                
            }
            else
            {
                let noNetConnection = -1009
                println(error.localizedDescription)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(jsonData: [:], networkError: noNetConnection)
                })
            }
            
        })
        
        task.resume()
    }
    
    class func getNewsFromRssFeed(url:String) -> [NewsItem]
    {
        var error:NSError?
        
        // url with the xml data
        var xmlURL = NSURL(string: url)
        var xmlData = NSData(contentsOfURL: xmlURL!)
        
        if xmlData != nil
        {
            // list of news items to be sent out of the function
            var newsItems = [NewsItem]()
            
            // checks to make sure there is data in the xmlDoc variable
            if let xmlDoc = AEXMLDocument(xmlData: xmlData!, error: &error)
            {
                for item in xmlDoc.rootElement["channel"]["item"].all
                {
                    var newNewsItem = NewsItem(title: item["title"].value, link: item["link"].value, description: item["description"].value)
                    newsItems.append(newNewsItem)
                }
            }
            return newsItems
        }
            
        else
        {
            println("ERROR: There was no xml data")
            return []
        }
        
    }
    
    

}














