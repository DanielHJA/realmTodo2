//
//  RealmObject.swift
//  RealTodo
//
//  Created by Daniel Hjärtström on 2018-06-07.
//  Copyright © 2018 Daniel Hjärtström. All rights reserved.
//

import UIKit
import RealmSwift

class RealmManager {
    
    private static let realm: Realm = {
        return try! Realm()
    }()
    
    class func items() -> Results<TodoItem> {
        return realm.objects(TodoItem.self)//.sorted(byKeyPath: "dateAdded", ascending: false)
    }
    
    class func add(_ object: TodoItem) {
        try! realm.write({
            realm.add(object)
        })
    }
    
    class func changeCompletionStatus(_ object: TodoItem) {
        try! realm.write({
            object.completed = !object.completed
        })
    }
    
    class func remove(_ object: TodoItem) {
        try! realm.write({
            realm.delete(object)
        })
    }
    
    class func makeTodoItemWith(_ title: String) -> TodoItem {
        let todoItem = TodoItem()
        todoItem.title = title
        todoItem.completed = false
        todoItem.dateAdded = Date()
        return todoItem
    }
    
}
