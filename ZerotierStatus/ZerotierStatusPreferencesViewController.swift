//
//  ZerotierStatusPreferencesViewController.swift
//  ZerotierStatus
//
//  Created by Cocoa on 28/03/2024.
//

import Foundation
import Cocoa

class ZerotierStatusPreferencesViewController: NSViewController, NSTextFieldDelegate {
    @IBOutlet weak var tokenTextField: NSTextField!
    
    override func viewDidLoad() {
        self.tokenTextField.target = self
        self.tokenTextField.isEditable = true
        self.tokenTextField.focusRingType = .none
        self.tokenTextField.delegate = self
    }
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if (commandSelector == #selector(NSResponder.insertNewline(_:))) {
            let appDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
            appDelegate.zerotierAPIKey = tokenTextField.stringValue
            return true
        }

        return false
    }
}
