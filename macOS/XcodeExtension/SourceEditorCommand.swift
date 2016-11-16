//
//  SourceEditorCommand.swift
//  XcodeExtension
//
//  Created by cyan on 2016/10/26.
//  Copyright © 2016年 cyan. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: xTextCommand {
  
  override func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
    if let service = OpenCCService(command: invocation.commandIdentifier) {
      xTextModifier.any(invocation: invocation, handler: { (text) -> (String) in
        service.convert(text)
      })
    }
    completionHandler(nil)
  }
}
