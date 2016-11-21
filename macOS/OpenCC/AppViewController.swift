//
//  AppViewController.swift
//  OpenCC
//
//  Created by cyan on 2016/10/26.
//  Copyright © 2016年 cyan. All rights reserved.
//

import Cocoa

enum SourceType: Int {
  case simplified = 0
  case traditional
}

enum VariantType: Int {
  case opencc = 0
  case taiwan
  case hongkong
}

enum IdiomType: Int {
  case disabled = 0
  case mainland
  case taiwan
}

class AppViewController: NSViewController, NSTextViewDelegate {
  
  @IBOutlet var inputTextView: NSTextView!
  @IBOutlet var outputTextView: NSTextView!
  
  @IBOutlet weak var originalControl: NSSegmentedControl!
  @IBOutlet weak var targetControl: NSSegmentedControl!
  @IBOutlet weak var variantControl: NSSegmentedControl!
  @IBOutlet weak var idiomControl: NSSegmentedControl!

  private var originalIndex = UserDefaults.standard.integer(forKey: "originalIndex") {
    didSet {
      UserDefaults.standard.set(originalIndex, forKey: "originalIndex")
      UserDefaults.standard.synchronize()
    }
  }
  
  private var targetIndex = UserDefaults.standard.integer(forKey: "targetIndex") {
    didSet {
      UserDefaults.standard.set(targetIndex, forKey: "targetIndex")
      UserDefaults.standard.synchronize()
    }
  }
  
  private var variantIndex = UserDefaults.standard.integer(forKey: "variantIndex") {
    didSet {
      UserDefaults.standard.set(variantIndex, forKey: "variantIndex")
      UserDefaults.standard.synchronize()
    }
  }
  
  private var idiomIndex = UserDefaults.standard.integer(forKey: "idiomIndex") {
    didSet {
      UserDefaults.standard.set(idiomIndex, forKey: "idiomIndex")
      UserDefaults.standard.synchronize()
    }
  }
  
  private let s2t = OpenCCService(converterType: .S2T)!
  private let t2s = OpenCCService(converterType: .T2S)!
  private let s2tw = OpenCCService(converterType: .S2TW)!
  private let tw2s = OpenCCService(converterType: .TW2S)!
  private let s2hk = OpenCCService(converterType: .S2HK)!
  private let hk2s = OpenCCService(converterType: .HK2S)!
  private let s2twp = OpenCCService(converterType: .S2TWP)!
  private let tw2sp = OpenCCService(converterType: .TW2SP)!
  private let t2hk = OpenCCService(converterType: .T2HK)!
  private let t2tw = OpenCCService(converterType: .T2TW)!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    UserDefaults.standard.register(defaults: ["targetIndex" : SourceType.traditional.rawValue])
    
    originalControl.selectedSegment = originalIndex
    targetControl.selectedSegment = targetIndex
    variantControl.selectedSegment = variantIndex
    idiomControl.selectedSegment = idiomIndex
  }
  
  func convert() {
    
    guard let string = inputTextView.string else { return }
    
    let orig = SourceType(rawValue: originalControl.selectedSegment)
    let tar = SourceType(rawValue: targetControl.selectedSegment)
    let variant = VariantType(rawValue: variantControl.selectedSegment)
    let idiom = IdiomType(rawValue: idiomControl.selectedSegment)
    
    var service: OpenCCService?
    
    // refer: http://opencc.byvoid.com/js/opencc.js
    if orig == .simplified {
      if tar == .simplified {
        // 簡體到簡體
      } else if tar == .traditional {
        // 簡體到繁體
        if variant == .opencc {
          // OpenCC 異體字
          if idiom == .disabled {
            // 不轉換詞彙
            service = s2t
          } else if idiom == .mainland {
            // 大陸詞彙(TODO)
          } else if idiom == .taiwan {
            // 臺灣詞彙(TODO)
          }
        } else if variant == .taiwan {
          // 臺灣異體字
          if idiom == .disabled {
            // 不轉換詞彙
            service = s2tw
          } else if idiom == .mainland {
            // 大陸詞彙(TODO)
          } else if idiom == .taiwan {
            // 臺灣詞彙
            service = s2twp
          }
        } else if variant == .hongkong {
          // 香港異體字
          if idiom == .disabled {
            // 不轉換詞彙
            service = s2hk
          } else if idiom == .mainland {
            // 大陸詞彙(TODO)
          } else if idiom == .taiwan {
            // 臺灣詞彙(TODO)
          }
        }
      }
    } else if orig == .traditional {
      if tar == .simplified {
        // 繁體到簡體
        if idiom == .disabled {
          // 不轉換詞彙
          service = t2s
        } else if idiom == .mainland {
          // 大陸詞彙
          service = tw2sp
        } else if idiom == .taiwan {
          // 臺灣詞彙（TODO）
        }
      } else if tar == .traditional {
        // 繁體到繁體
        if variant == .opencc {
          // OpenCC異體字
          if idiom == .disabled {
            // 不轉換詞彙
          } else if idiom == .mainland {
            // 大陸詞彙
          } else if idiom == .taiwan {
            // 臺灣詞彙
          }
        } else if variant == .taiwan {
          // 臺灣異體字
          if idiom == .disabled {
            // 不轉換詞彙
          } else if idiom == .mainland {
            // 大陸詞彙(TODO)
          } else if idiom == .taiwan {
            // 臺灣詞彙
          }
        }
      }
    }
    
    if let service = service {
      outputTextView.string = service.convert(string)
    } else {
      outputTextView.string = string
    }
  }
  
  func textDidChange(_ notification: Notification) {
    convert()
  }
  
  @IBAction func segmentedControlDidChange(_ sender: NSSegmentedControl) {
    
    let index = sender.selectedSegment
    if sender == originalControl {
      originalIndex = index
    } else if sender == targetControl {
      targetIndex = index
    } else if sender == variantControl {
      variantIndex = index
    } else if sender == idiomControl {
      idiomIndex = index
    }
    
    convert()
  }
  
  @IBAction func openGitHub(_ sender: NSButton) {
    if let url = URL(string: kGitHubURL) {
      NSWorkspace.shared().open(url)
    }
  }
  
  func openPreferences(_ sender: NSButton) {
    NSAppleScript(source: kOpenPreferences)?.executeAndReturnError(nil)
  }
}

