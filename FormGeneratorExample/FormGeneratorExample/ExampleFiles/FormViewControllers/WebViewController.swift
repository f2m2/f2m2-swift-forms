//
//  WebViewController.swift
//  ExampleUsage
//
//  Created by Michael L Mork on 12/8/14.
//  Copyright (c) 2014 f2m2. All rights reserved.
//

import Foundation
import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webViewController: UIWebView!
    
    override func viewDidLoad() {
        
        let request = NSURLRequest(URL: NSURL(string: "http://www.f2m2.com")!)
        webViewController.loadRequest(request)

    }
    
}