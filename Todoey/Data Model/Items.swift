//
//  Items.swift
//  Todoey
//
//  Created by Yedige Ashirbek on 19.12.2022.
//

import Foundation

class Items: Encodable, Decodable {
    var title: String = ""
    var done: Bool = false
}
