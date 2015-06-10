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
    
    // the only purpose of this viewcontroller is to load RTF file into the textview
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load About.rtf
        let path = NSBundle.mainBundle().URLForResource("About", withExtension: "rtf")
        
        // turn it into an Attributed string
        let text = NSAttributedString(fileURL: path, options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes: nil, error: nil)
        
        
        // put the text in the textview
        textView.attributedText = text!
    }

}
