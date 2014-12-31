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
    
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    
    let whoIsInSpaceAPI = WhoIsInSpaceAPI()
    
    var listOfAstronaut: [Astronaut] = []
    var currentISSLocation : (Double, Double, Int)?
    var currentISSLongitude: Double?
    var currentISSLatitude: Double?
    var currentISSTime: Int?
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    
        self.whoIsInSpaceAPI.setup(self.tableView)
        self.whoIsInSpaceAPI.currentLoctionOfISS { (location) -> (Void) in
            self.latitudeLabel.text = "\(location.1)"
            self.longitudeLabel.text = "\(location.0)"
        }
        
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.whoIsInSpaceAPI.astroList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("CELL", forIndexPath: indexPath) as UITableViewCell
        var data = self.whoIsInSpaceAPI.astroList[indexPath.row]
        cell.textLabel?.text = data.name as String
        
        
        
        return cell
    }

}

