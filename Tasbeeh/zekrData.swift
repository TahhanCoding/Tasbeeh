//  zekrData.swift
//  Tasbeeh
//  Created by Ahmed Shaban on 03/08/2022.

import UIKit

class Zekr: Codable {
    var text: String
    var counter: Int 
    
    init(text: String, counter: Int) {
        self.text = text
        self.counter = counter
    }
}


