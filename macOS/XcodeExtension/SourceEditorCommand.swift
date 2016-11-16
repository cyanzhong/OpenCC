//
//  SourceEditorCommand.swift
//  XcodeExtension
//
//  Created by cyan on 2016/10/26.
//  Copyright © 2016年 cyan. All rights reserved.
//

import Foundation
import XcodeKit

extension String {
  
    func convert(type: OpenCCServiceConverterType) -> String {
        if let service = OpenCCService(converterType: type) {
            return service.convert(self)
        } else {
            return self
        }
    }
    
    func s2t() -> String {
        return convert(type: .S2TWP)
    }
    
    func t2s() -> String {
        return convert(type: .T2S)
    }
}

class SourceEditorCommand: xTextCommand {
    override func handlers() -> Dictionary<String, xTextModifyHandler> {
        return [
            "traditional": { text -> String in text.s2t() },
            "simplified": { text -> String in text.t2s() }
        ]
    }
}
