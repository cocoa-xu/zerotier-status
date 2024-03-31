//
//  AppDelegate.swift
//  ZerotierStatus
//
//  Created by Cocoa on 24/03/2024.
//

import Cocoa
import AppKit

class ZerotierNSMenuItem: NSMenuItem {
    var peer: ZerotierPeer!
}

class ZerotierPeer {
    var networkID: String!
    var networkName: String!
    var nodeId: String!
    var name: String!
    var description: String!
    var physicalAddress: String!
    var lastOnline: UInt64!
    var lastSeen: UInt64!
    var ipAssignments: [String]!
}

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!
    var updateTimer: Timer?
    var statusBarIcon: ZerotierStatusBarIcon
    var menu: NSMenu
    var statusMenu: NSMenu
    var outOfSyncTime: TimeInterval! = 0
    var errorMessage: String!
    var errorMessageItem: NSMenuItem!
    var preferencesItem: NSMenuItem!
    var quitItem: NSMenuItem!
    var peers: [ZerotierPeer]!
    
    let ZEROTIER_STATUS_APIKEY: String! = "ZerotierAPIKey"
    let ZEROTIER_STATUS_UPDATE_FREQ_TIMEUNIT: String! = "ZerotierUpdateFreqTimeUnit"
    let ZEROTIER_STATUS_UPDATE_FREQ_VALUE: String! = "ZerotierUpdateFreqValue"
    var zerotierAPIKey: String? {
        didSet {
            guard let zerotierAPIKey = zerotierAPIKey else { return }
            let queue = DispatchQueue(label: "moe.uwucocoa.ZerotierStatus")
            queue.async {
                try! AsymmetricUserDefaults().setValue(zerotierAPIKey, forKey: self.ZEROTIER_STATUS_APIKEY)
            }
        }
    }
    var updateFreqTimeUnit: UInt {
        didSet {
            let queue = DispatchQueue(label: "moe.uwucocoa.ZerotierStatus")
            queue.async {
                try! AsymmetricUserDefaults().setValue("\(self.updateFreqTimeUnit)", forKey: self.ZEROTIER_STATUS_UPDATE_FREQ_TIMEUNIT)
                self.updateTimerInterval()
            }
        }
    }
    var updateFreqValue: UInt {
        didSet {
            let queue = DispatchQueue(label: "moe.uwucocoa.ZerotierStatus")
            queue.async {
                try! AsymmetricUserDefaults().setValue("\(self.updateFreqValue)", forKey: self.ZEROTIER_STATUS_UPDATE_FREQ_VALUE)
                self.updateTimerInterval()
            }
        }
    }
    
    let preferencesWindow: NSWindowController = {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let preferencesWindow = storyboard.instantiateController(withIdentifier: "ZerotierStatusPreferences") as! NSWindowController
        return preferencesWindow
    }()

    required override init() {
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: 18)
        self.statusBarIcon = ZerotierStatusBarIcon.init(frame: NSMakeRect(0, 0, 18, 18))
        self.menu = NSMenu.init()
        self.statusBarItem.menu = self.menu
        if let button = self.statusBarItem.button {
            button.addSubview(self.statusBarIcon)
        }
        
        self.statusMenu = NSMenu(title: "ZerotierStatusMenu")
        self.errorMessageItem = NSMenuItem.init(title: "", action: nil, keyEquivalent: "")
        self.errorMessageItem.isEnabled = false
        self.preferencesItem = NSMenuItem(title: "Preferences...", action: #selector(AppDelegate.showPreferences), keyEquivalent: ",")
        self.quitItem = NSMenuItem(title: "Quit", action: #selector(AppDelegate.quit), keyEquivalent: "q")
        self.statusBarItem.menu = statusMenu
        self.errorMessage = ""
        self.peers = Array()
        
        self.updateFreqTimeUnit = UInt((try? AsymmetricUserDefaults().getValue(forKey: self.ZEROTIER_STATUS_UPDATE_FREQ_TIMEUNIT) ?? "1")!) ?? 1
        self.updateFreqValue = UInt((try? AsymmetricUserDefaults().getValue(forKey: self.ZEROTIER_STATUS_UPDATE_FREQ_VALUE) ?? "5")!) ?? 5
        
        super.init()
        self.updateMenu()
    }
    
    func updateMenu() {
        self.statusMenu.removeAllItems()
        
        self.zerotierAPIKey = try? AsymmetricUserDefaults().getValue(forKey: self.ZEROTIER_STATUS_APIKEY) ?? nil

        if self.zerotierAPIKey == nil || self.zerotierAPIKey!.isEmpty {
            self.errorMessage = "No API Token Found"
        }
        
        if !self.errorMessage.isEmpty {
            self.errorMessageItem.title = self.errorMessage
            self.statusMenu.addItem(self.errorMessageItem)
            self.statusMenu.addItem(NSMenuItem.separator())
        }
        
        self.peers.forEach { peer in
            let menu = ZerotierNSMenuItem(title: peer.name, action: #selector(AppDelegate.copyFirstIP(_:)), keyEquivalent: "")
            menu.peer = peer
            let detailMenu = ZerotierPeerDetailMenu(title: peer.name)
            detailMenu.peer = peer
            menu.submenu = detailMenu
            self.statusMenu.addItem(menu)
        }
        
        self.statusMenu.addItem(NSMenuItem.separator())
        self.statusMenu.addItem(self.preferencesItem)
        self.statusMenu.addItem(self.quitItem)
    }
    
    @objc func copyFirstIP(_ sender: ZerotierNSMenuItem) {
        guard let ipAssignments = sender.peer.ipAssignments else { return }
        guard let ip = ipAssignments.first else { return }
        NSPasteboard.general.declareTypes([.string], owner: nil)
        NSPasteboard.general.setString(ip, forType: .string)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.updateTimerInterval()
        self.updateTimer?.fire()
    }
    
    func updateTimerInterval() {
        var interval: UInt = 1
        switch self.updateFreqTimeUnit {
        case 0:
            // seconds
            interval = 1
        case 1:
            // minutes
            interval = 60
        case 2:
            // hours
            interval = 3600
        case 3:
            // days
            interval = 3600 * 24
        default:
            interval = 60
        }
        interval *= self.updateFreqValue
        
        if self.updateTimer != nil {
            self.updateTimer!.invalidate()
        }
        
        self.updateTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: true) { timer in
            let queue = DispatchQueue(label: "moe.uwucocoa.ZerotierStatus")
            queue.async { self.refreshNetwork() }
        }
    }
    
    @objc func refreshNetwork() {
        guard let apiToken = self.zerotierAPIKey else { return }
        ZerotierStatusAPI.getZeroTierNetworkIDs(apiToken: apiToken) { result in
            switch result {
            case .success(let data):
                self.parseNetworkIDs(data: data)
                self.outOfSyncTime = 0
                self.errorMessage = ""
            case .failure(let error):
                if self.outOfSyncTime == 0 {
                    self.outOfSyncTime = Date().timeIntervalSince1970
                }
                self.errorMessage = "Failed to sync since"
                print(error.localizedDescription)
            }
        }
    }
    
    func refreshPeer(networkID: String, networkName: String) {
        guard let apiToken = self.zerotierAPIKey else { return }
        ZerotierStatusAPI.getZeroTierNetworkMembers(apiToken: apiToken, networkId: networkID) { result in
            switch result {
            case .success(let data):
                self.parseNetworkPeers(networkID: networkID, networkName: networkName, data: data)
                self.outOfSyncTime = 0
                self.errorMessage = ""
            case .failure(_):
                if self.outOfSyncTime == 0 {
                    self.outOfSyncTime = Date().timeIntervalSince1970
                }
                self.errorMessage = "Failed to sync since"
            }
        }
    }
    
    func parseNetworkIDs(data: Data) {
        self.peers.removeAll()
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                for member in jsonArray {
                    if let id = member["id"] as? String,
                       let config = member["config"] as? [String: Any],
                       let name = config["name"] as? String {
                        print("Found network: ID=\(id), name=\(name)")
                        self.refreshPeer(networkID: id, networkName: name)
                    }
                }
            }
        } catch {
            print("Error parsing JSON: \(error.localizedDescription)")
        }
    }
    
    func parseNetworkPeers(networkID: String, networkName: String, data: Data) {
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                for member in jsonArray {
                    if let nodeId = member["nodeId"] as? String,
                       let name = member["name"] as? String,
                       let description = member["description"] as? String,
                       let physicalAddress = member["physicalAddress"] as? String,
                       let lastOnline = member["lastOnline"] as? UInt64,
                       let lastSeen = member["lastSeen"] as? UInt64,
                       let config = member["config"] as? [String: Any],
                       let ipAssignments = config["ipAssignments"] as? [String]
                    {
                        let peer: ZerotierPeer = ZerotierPeer()
                        peer.networkID = networkID
                        peer.networkName = networkName
                        peer.nodeId = nodeId
                        peer.name = name
                        peer.description = description
                        peer.physicalAddress = physicalAddress
                        peer.lastOnline = lastOnline
                        peer.lastSeen = lastSeen
                        peer.ipAssignments = ipAssignments
                        print("Found network peer: ID=\(networkID), nodeId=\(nodeId)")
                        self.peers.append(peer)
                        let queue = DispatchQueue.main
                        queue.sync {
                            self.updateMenu()
                        }
                    }
                }
            }
        } catch {
            print("Error parsing JSON: \(error.localizedDescription)")
        }
    }
    
    @objc func showPreferences() {
        self.preferencesWindow.showWindow(self)
        let vc = self.preferencesWindow.contentViewController as! ZerotierStatusPreferencesViewController
        vc.tokenTextField.stringValue = self.zerotierAPIKey ?? ""
        vc.updateFreqTextField.stringValue = "\(self.updateFreqValue)"
        vc.updateFreqComboBox.selectItem(at: Int(self.updateFreqTimeUnit))
        vc.updateFreqStepper.floatValue = Float(self.updateFreqValue)
        self.preferencesWindow.window?.orderFrontRegardless()
    }
    
    @objc func quit() {
        NSApplication.shared.terminate(self)
    }
}
