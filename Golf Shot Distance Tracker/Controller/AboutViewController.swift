//
//  AboutViewController.swift
//  Golf Shot Distance Tracker
//
//  Created by Benjamin Lazar on 6/4/15.
//  Copyright (c) 2015 Benjamin Lazar. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let path = NSBundle.mainBundle().URLForResource("About", withExtension: "rtf")
        
        let text = NSAttributedString(fileURL: path, options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes: nil, error: nil)
        
        textView.attributedText = text!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
