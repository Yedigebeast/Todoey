//
//  Category.swift
//  Todoey
//
//  Created by Yedige Ashirbek on 23.01.2023.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var hexValueOfBackgroundColor: String = ""
    var items = List<Item>()
}
