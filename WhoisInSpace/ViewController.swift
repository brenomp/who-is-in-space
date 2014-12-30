//
//  ViewController.swift
//  WhoisInSpace
//
//  Created by David on 12/24/14.
//  Copyright (c) 2014 David Fry. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet weak var tableView: UITableView!
    
    var listOfAstronaut: [Astronaut] = []
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.getJsonData()
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.listOfAstronaut.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("CELL", forIndexPath: indexPath) as UITableViewCell
        var data = self.listOfAstronaut[indexPath.row]
        cell.textLabel?.text = data.name as String
        
        return cell
    }
    
    func getJsonData()
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
                
//                println(peopleInSpaceDict)
                
                let currentAstronautList = AstronautList(peopleInSpaceDict: peopleInSpaceDict)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.listOfAstronaut = currentAstronautList.listOfAstronautsInSpace!
                    self.tableView.reloadData()
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

