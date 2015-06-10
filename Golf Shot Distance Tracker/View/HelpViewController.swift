//
//  HelpViewController.swift
//  Golf Shot Distance Tracker
//
//  Created by Benjamin Lazar on 6/10/15.
//  Copyright (c) 2015 Benjamin Lazar. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    
    // only purpose of this view controller is to load help file in RTF
    override func viewDidLoad() {
        super.viewDidLoad()

        // load Help.rtf
        let path = NSBundle.mainBundle().URLForResource("Help", withExtension: "rtf")
        
        // create attributed string
        let text = NSAttributedString(fileURL: path, options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes: nil, error: nil)
        
        // set the textView to the text
        textView.attributedText = text!

    }

}
