//
//  Logger.swift
//  RemoteMedia
//
//  Created by Dinesh Thangasamy on 2018-04-18.
//  Copyright © 2018 datatrix. All rights reserved.
//

import Foundation
class Logger: NSObject {
    
    static let shared = Logger()
    // private prevents others from using the default '()' initializer for this class (== Singleton)
    private override init() {
        super.init()
    }
    
    var logString = ""
    
    func appendLog(_ log: String) {
        self.logString += "\n" + log
    }
    
    func clearLogs() {
        self.logString = ""
    }
}
