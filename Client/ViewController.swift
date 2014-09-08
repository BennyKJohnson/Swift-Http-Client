//
//  ViewController.swift
//  Client
//
//  Created by Ben Johnson on 8/09/2014.
//  Copyright (c) 2014 Ben Johnson. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        let client = Client();
        client.sendGetRequestTo("http://pricetag.net.au/api/products/175", isDownload: true)
        
        
     
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

