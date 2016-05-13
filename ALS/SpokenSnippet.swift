//
//  SpokenSnippet.swift
//  Sprechen
//
//  Created by Per Schulte on 12.05.16.
//  Copyright © 2016 Per Schulte. All rights reserved.
//

import Foundation

class SpokenSnippet {
    var text = ""
    var lastUsed = NSDate()
    
    init(_ text: String) {
        self.text = text
    }
}

