//
//  ViewController.swift
//  OpenCC
//
//  Created by cyan on 2016/10/26.
//  Copyright © 2016年 cyan. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
  }
  
  func openPreferences(_ sender: NSButton) {
    let script = NSAppleScript(source: "tell application \"System Preferences\"\n\tset the current pane to pane \"com.apple.preferences.extensions\"\n\tactivate\nend tell")
    script?.executeAndReturnError(nil)
  }
}

