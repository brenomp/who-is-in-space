//
//  NewsFeedViewController.swift
//  WhoisInSpace
//
//  Created by David Fry on 1/16/15.
//  Copyright (c) 2015 David Fry. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    @IBOutlet var newsFeedTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.newsFeedTableView.dataSource = self
        self.newsFeedTableView.delegate = self
        
//        self.newsFeedTableView.estimatedRowHeight = 44.0
//        self.newsFeedTableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        self.newsFeedTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return WhoIsInSpaceAPI.sharedInstance.currentNewsItems.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = self.newsFeedTableView.dequeueReusableCellWithIdentifier("NEWS_CELL", forIndexPath: indexPath) as UITableViewCell
        var newsItem = WhoIsInSpaceAPI.sharedInstance.currentNewsItems[indexPath.row]
        
        // Sets color of the text in the cell
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.detailTextLabel?.textColor = UIColor.whiteColor()
        
        // Sets the lables in the cell
        cell.textLabel?.text = newsItem.title
        cell.detailTextLabel?.text = newsItem.description
        
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        var destVC = segue.destinationViewController as WebView
        var indexPath = self.newsFeedTableView.indexPathForSelectedRow()?.row
        destVC.newsItem = WhoIsInSpaceAPI.sharedInstance.currentNewsItems[indexPath!]
    }


    

}
