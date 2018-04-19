//
//  ViewController.swift
//  RemoteMedia
//
//  Created by Dinesh Thangasamy on 2018-04-18.
//  Copyright © 2018 datatrix. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BonjourServiceDelegate {
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var logsView: UITextView!

    var linkToSend = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        BonjourService.shared.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: IBActions
    @IBAction func lookForVideos(_ sender: Any) {
        Logger.shared.appendLog("Looking for videos in \(self.urlTextField.text!)")
        self.logsView.text = Logger.shared.logString
    }
    
    @IBAction func sendVideo(_ sender: Any) {
        Logger.shared.appendLog("Send the video in \(self.urlTextField.text!) to server")
        self.logsView.text = Logger.shared.logString
        
        BonjourService.shared.startService({ (completed, error) in
            if completed {
                Logger.shared.appendLog("Started server")
                self.clearLogs(self.urlTextField)
                self.linkToSend = self.urlTextField.text!
            } else {
                Logger.shared.appendLog("Failed to Start server")
            }
        })
    }
    
    @IBAction func clearLogs(_ sender: Any) {
        //Logger.shared.clearLogs()
        self.logsView.text = Logger.shared.logString
    }
    
    //MARK: Bonjour server delegate
    func didFindServers() {
        BonjourService.shared.server.connect(toRemoteService: BonjourService.shared.services.first!)
        if let data = self.urlTextField.text?.data(using: .utf8) {
            let dataResponse = BonjourService.shared.server.send(data)
            /*BonjourService.shared.stopService({ (completed, error) in
                if completed {
                    Logger.shared.appendLog("Stopped server")
                } else {
                    Logger.shared.appendLog("Failed to Stop server")
                }
            })*/
            print("did sent data")
        } else {
            BonjourService.shared.stopService({ (completed, error) in
                if completed {
                    Logger.shared.appendLog("Stopped server")
                } else {
                    Logger.shared.appendLog("Failed to Stop server")
                }
            })
        }
    }
}

