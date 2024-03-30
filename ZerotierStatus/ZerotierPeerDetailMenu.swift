//
//  ZerotierPeerDetailMenu.swift
//  ZerotierStatus
//
//  Created by Cocoa on 30/03/2024.
//

import Foundation
import Cocoa
import AppKit

class ZerotierPeerDetailMenu: NSMenu {
    let dateFormatter = DateFormatter()
    let width: CGFloat = 260.0
    let detailLabelFont = NSFont.systemFont(ofSize: 12.0)
    var peer: ZerotierPeer! {
        didSet {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            var entry = NSMenuItem.init()
            var view = ZerotierPeerDetailMenuItem.init(frame: NSMakeRect(0, 0, self.width, 25))
            view.update("Network ID", peer.networkID)
            view.detailLabel.font = self.detailLabelFont
            entry.view = view
            self.addItem(entry)
            
            entry = NSMenuItem.init()
            view = ZerotierPeerDetailMenuItem.init(frame: NSMakeRect(0, 0, self.width, 25))
            view.update("Network Name", peer.networkName)
            view.detailLabel.font = self.detailLabelFont
            entry.view = view
            self.addItem(entry)
            
            self.addItem(NSMenuItem.separator())
            
            entry = NSMenuItem.init()
            view = ZerotierPeerDetailMenuItem.init(frame: NSMakeRect(0, 0, self.width, 25))
            view.update("ID", peer.nodeId)
            view.detailLabel.font = self.detailLabelFont
            entry.view = view
            self.addItem(entry)
            
            entry = NSMenuItem.init()
            view = ZerotierPeerDetailMenuItem.init(frame: NSMakeRect(0, 0, self.width, 25))
            view.update("Name", peer.name)
            view.detailLabel.font = self.detailLabelFont
            entry.view = view
            self.addItem(entry)
            
            entry = NSMenuItem.init()
            view = ZerotierPeerDetailMenuItem.init(frame: NSMakeRect(0, 0, self.width, 25))
            view.update("Descrption", peer.description)
            view.detailLabel.font = self.detailLabelFont
            entry.view = view
            self.addItem(entry)
            
            entry = NSMenuItem.init()
            view = ZerotierPeerDetailMenuItem.init(frame: NSMakeRect(0, 0, self.width, 25))
            view.update("Phy Addr", peer.physicalAddress)
            view.detailLabel.font = self.detailLabelFont
            entry.view = view
            self.addItem(entry)
            
            entry = NSMenuItem.init()
            view = ZerotierPeerDetailMenuItem.init(frame: NSMakeRect(0, 0, self.width, 25))
            view.update("Last Online", dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(self.peer.lastOnline / 1000))))
            view.detailLabel.font = self.detailLabelFont
            entry.view = view
            self.addItem(entry)
            
            entry = NSMenuItem.init()
            view = ZerotierPeerDetailMenuItem.init(frame: NSMakeRect(0, 0, self.width, 25))
            view.update("Last Seen", dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(self.peer.lastSeen / 1000))))
            view.detailLabel.font = self.detailLabelFont
            entry.view = view
            self.addItem(entry)
            
            entry = NSMenuItem.init(title: "IP Assignments", action: nil, keyEquivalent: "")
            let ipMenu = NSMenu(title: "IP Assignments")
            self.peer.ipAssignments.forEach { ip in
                ipMenu.addItem(NSMenuItem(title: ip, action: nil, keyEquivalent: ""))
            }
            entry.submenu = ipMenu
            self.addItem(entry)
        }
    }
}

class ZerotierPeerDetailMenuItem: NSView {
    var titleLabel: NSTextField
    var detailLabel: NSTextField
    
    let rightAlignment: NSParagraphStyle = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        paragraphStyle.baseWritingDirection = .natural
        return paragraphStyle
    }()
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
    
    required init?(coder: NSCoder) {
        self.titleLabel = NSTextField.init()
        self.detailLabel = NSTextField.init()
        super.init(coder: coder)
    }
    
    override init(frame frameRect: NSRect) {
        let margin: CGFloat = 10
        self.titleLabel = NSTextField.init(frame: NSMakeRect(margin, 0, frameRect.width / 2 - margin, frameRect.height))
        self.detailLabel = NSTextField.init(frame: NSMakeRect(margin, 0, frameRect.width - margin * 2, frameRect.height))
        self.titleLabel.cell = ZerotierStatusTextFieldCell()
        self.titleLabel.isBezeled = false
        self.titleLabel.backgroundColor = NSColor.clear
        self.titleLabel.isEditable = false
        self.titleLabel.isSelectable = false
        
        self.detailLabel.cell = ZerotierStatusTextFieldCell()
        self.detailLabel.isBezeled = false
        self.detailLabel.backgroundColor = NSColor.clear
        self.detailLabel.isEditable = false
        self.detailLabel.isSelectable = false
        
        super.init(frame: frameRect)
        self.addSubview(self.titleLabel)
        self.addSubview(self.detailLabel)
        
        let click = NSClickGestureRecognizer.init(target: self, action: #selector(ZerotierPeerDetailMenuItem.copyDetailInfo(_:)))
        self.detailLabel.addGestureRecognizer(click)
    }
    
    func update(_ title: String, _ value: String) {
        var r = NSMutableAttributedString.init(string: title)
        r.addAttribute(.foregroundColor, value: NSColor.black, range: NSMakeRange(0, title.count))
        self.titleLabel.attributedStringValue = r
        
        r = NSMutableAttributedString.init(string: value)
        r.addAttribute(.foregroundColor, value: NSColor.gray, range: NSMakeRange(0, value.count))
        r.addAttribute(.paragraphStyle, value: rightAlignment, range: NSMakeRange(0, value.count))
        self.detailLabel.attributedStringValue = r
    }
    
    @objc func copyDetailInfo(_ sender: NSClickGestureRecognizer) {
        NSPasteboard.general.declareTypes([.string], owner: nil)
        NSPasteboard.general.setString(self.detailLabel.stringValue, forType: .string)
    }
}
