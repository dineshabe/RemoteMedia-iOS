//
//  BonjourService.swift
//  RemoteMedia
//
//  Created by Dinesh Thangasamy on 2018-04-17.
//  Copyright © 2018 datatrix. All rights reserved.
//

import Foundation
import Merhaba

enum BonjourServiceStatus {
    case running
    case stopped
    case starting
    case stopping
    case browsing
    case idle
}

enum BonjourServiceMode {
    case server
    case client
}

@objc protocol BonjourServiceDelegate {
    @objc optional func didFindServers()
    @objc optional func didGetUrl(_ urlStr:String)
}

class BonjourService: NSObject, MRBServerDelegate {
    
    static let shared = BonjourService()
    // private prevents others from using the default '()' initializer for this class (== Singleton)
    private override init() {
        super.init()
        self.server.delegate = self
    }
    
    var status: BonjourServiceStatus = .stopped
    var currentMode: BonjourServiceMode = .server
    var server = MRBServer(withProtocol: "remoteMedia")
    var services = [NetService]()
    var delegate: BonjourServiceDelegate?
    
    func startService(_ completion: @escaping (_ completed: Bool, _ error: NSError?) -> Void) {
        var didStart = true
        self.status = .starting
        defer {
            completion(didStart,nil)
        }
        do {
            try self.server.start()
            self.status = .running
        } catch {
            self.status = .stopped
        }
    }
    
    func stopService(_ completion: @escaping (_ completed: Bool, _ error: NSError?) -> Void) {
        self.status = .stopping
        self.server.stop()
        self.status = .stopped
        completion(true,nil)
    }
    
    //MARK: MRBServerDelegate
    func serverRemoteConnectionComplete(_ server: MRBServer) {
        Logger.shared.appendLog("Server connection complete")
    }
    
    func server(_ server: MRBServer, didAccept data: Data) {
        let url = String(data: data, encoding: .utf8)
        Logger.shared.appendLog("Server received data \(url)")
        self.delegate?.didGetUrl!(url!)
    }
    
    func server(_ server: MRBServer, lostConnection errorDict: [AnyHashable : Any]?) {
        Logger.shared.appendLog("Server lost connection")
    }
    
    func server(_ server: MRBServer, didNotStart errorDict: [AnyHashable : Any]) {
        self.status = .stopped
        Logger.shared.appendLog("Failed to start server")
    }
    
    func serverStopped(_ server: MRBServer) {
        self.status = .stopped
        Logger.shared.appendLog("Server started")
    }
    
    func serviceAdded(_ service: NetService, moreComing more: Bool) {
        Logger.shared.appendLog("serviceAdded")
        switch self.currentMode {
        case .server:
            self.server.connect(toRemoteService: service)
        case .client:
            if let _ = self.services.index(of: service) {
                //Do not add if this is already in the array
            } else {
                self.services.append(service)
                if !more {
                    self.delegate?.didFindServers!()
                }
            }
        }
    }
    
    func serviceRemoved(_ service: NetService, moreComing more: Bool) {
        Logger.shared.appendLog("serviceAdded")
        switch self.currentMode {
        case .server:
            print("do nothing")
        case .client:
            if let index = self.services.index(of: service) {
                self.services.remove(at: index)
            }
        }
    }
}
