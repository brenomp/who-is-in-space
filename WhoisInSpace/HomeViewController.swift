//
//  HomeViewController.swift
//  WhoisInSpace
//
//  Created by David on 1/8/15.
//  Copyright (c) 2015 David Fry. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var overheadPassTableView: UITableView!
    
    let whosInSpaceApi = WhoIsInSpaceAPI()
    
    var issCurrentLat: Double?
    var issCurrentLon: Double?
    var issCurrentTime: String?
    
    var myLatitude: Double?
    var myLongitude: Double?
    
    var overheadPassList = [NSDictionary]()
    var riseTime: String?
    var duration: String?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.overheadPassTableView.dataSource = self
        self.overheadPassTableView.delegate = self
        
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
                        self.overheadPassList = dateTime
//                        self.riseTime = self.whosInSpaceApi.dateStringFromUnixtime(dateTime[0]["risetime"]! as Int)
//                        self.duration = dateTime[0]["duration"]! as? String
                        self.overheadPassTableView.reloadData()
                        
                    })
                }

            }

        }
   
        // Gets the current location of the international space station
        self.whosInSpaceApi.getCurrentLoctionOfISS { (location) -> (Void) in
            self.latitudeLabel.text = self.formatDoubleString(location.latitude, precision: 4)
            self.longitudeLabel.text = self.formatDoubleString(location.longitude, precision: 4)
            

        }
        

    }

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.overheadPassList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = self.overheadPassTableView.dequeueReusableCellWithIdentifier("OVERHEAD_PASS_CELL", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = self.overheadPassList[indexPath.row]["risetime"]! as? String
//        cell.textLabel?.text = "\(indexPath.row)"
        return cell
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
