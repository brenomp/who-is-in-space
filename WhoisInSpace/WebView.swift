//
//  WebView.swift
//  WhoisInSpace
//
//  Created by David Fry on 1/16/15.
//  Copyright (c) 2015 David Fry. All rights reserved.
//

import UIKit

class WebView: UIViewController, UIWebViewDelegate
{

    @IBOutlet var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var newsItem: NewsItem?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.webView.delegate = self
        self.loadWebPage()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadWebPage()
    {
        var urlString = self.newsItem!.link
        var url = NSURL(string: urlString)
        
        var request = NSURLRequest(URL: url!)
        self.webView.loadRequest(request)
    }
    
    
    func webViewDidStartLoad(webView: UIWebView)
    {
        self.activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView)
    {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidesWhenStopped = true
    }
}
