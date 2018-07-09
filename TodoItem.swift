//
//  TodoItem.swift
//  RealTodo
//
//  Created by Daniel Hjärtström on 2018-06-07.
//  Copyright © 2018 Daniel Hjärtström. All rights reserved.
//

import UIKit
import RealmSwift

class TodoItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var completed: Bool = false
    @objc dynamic var dateAdded = Date()
}
