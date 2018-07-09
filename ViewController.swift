//
//  ViewController.swift
//  RealTodo
//
//  Created by Daniel Hjärtström on 2018-06-07.
//  Copyright © 2018 Daniel Hjärtström. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    private var todoItems: Results<TodoItem> = {
        return RealmManager.items()
    }()

    private lazy var tableView: UITableView = {
        let temp = UITableView()
        temp.delegate = self
        temp.dataSource = self
        temp.backgroundColor = UIColor.white
        temp.register(TodoItemTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        temp.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        temp.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        return temp
    }()
    
    private lazy var rightbarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem = rightbarButtonItem
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func add() {
        let controller = UIAlertController(title: "Add", message: "Add a new item", preferredStyle: .alert)
       
        controller.addTextField { (textfield) in
            textfield.placeholder = "Enter a new item"
        }
        
        let okAction = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let textfield = controller.textFields?.first else { return }
            guard let title = textfield.text, title.count > 0 else { return }
            let item = RealmManager.makeTodoItemWith(title)
            RealmManager.add(item)
            self.insertRow()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        controller.addAction(cancelAction)
        controller.addAction(okAction)

        present(controller, animated: true, completion: nil)
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TodoItemTableViewCell else {  return UITableViewCell() }
        
        cell.setupCellWith(todoItems[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let object = todoItems[indexPath.row]
            RealmManager.remove(object)
            deleteRow(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        RealmManager.changeCompletionStatus(todoItems[indexPath.row])
        reloadRowsAt(indexPath)
    }
    
    private func reloadRowsAt(_ index: IndexPath) {
        tableView.beginUpdates()
        tableView.reloadRows(at: [index], with: .automatic)
        tableView.endUpdates()
    }
    
    private func insertRow() {
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: todoItems.count - 1, section: 0)], with: .right)
        tableView.endUpdates()
    }
    
    private func deleteRow(indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .left)
        tableView.endUpdates()
    }
}
