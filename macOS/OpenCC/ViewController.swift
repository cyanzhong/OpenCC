//
//  ViewController.swift
//  OpenCC
//
//  Created by cyan on 2016/10/26.
//  Copyright © 2016年 cyan. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextViewDelegate {
  
  @IBOutlet var inputTextView: NSTextView!
  @IBOutlet var outputTextView: NSTextView!
  
  let s2twp = OpenCCService(converterType: .S2TWP)!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
  }
  
  func convert() {
    if let string = inputTextView.string {
      outputTextView.string = s2twp.convert(string)
    }
  }
  
  func textDidChange(_ notification: Notification) {
    convert()
  }
  
  @IBAction func segmentedControlDidChange(_ sender: NSSegmentedControl) {
    convert()
  }
  
  @IBAction func openGitHub(_ sender: NSButton) {
    if let url = URL(string: "https://github.com/cyanzhong/OpenCC") {
      NSWorkspace.shared().open(url)
    }
  }
  
  func openPreferences(_ sender: NSButton) {
    let script = NSAppleScript(source: "tell application \"System Preferences\"\n\tset the current pane to pane \"com.apple.preferences.extensions\"\n\tactivate\nend tell")
    script?.executeAndReturnError(nil)
  }
}

