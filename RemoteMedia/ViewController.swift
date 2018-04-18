//
//  ViewController.swift
//  RemoteMedia
//
//  Created by Dinesh Thangasamy on 2018-04-18.
//  Copyright © 2018 datatrix. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var logsView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func lookForVideos(_ sender: Any) {
        Logger.shared.appendLog("Looking for videos in \(self.urlTextField.text!)")
        self.logsView.text = Logger.shared.logString
    }
    
    @IBAction func sendVideo(_ sender: Any) {
        Logger.shared.appendLog("Send the video in \(self.urlTextField.text!) to server")
        self.logsView.text = Logger.shared.logString
    }
    
    @IBAction func clearLogs(_ sender: Any) {
        Logger.shared.clearLogs()
        self.logsView.text = Logger.shared.logString
    }
}

