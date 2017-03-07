//
//  ViewController.swift
//  pset4 sem sturkenboom
//
//  Created by Sem Sturkenboom on 06-03-17.
//  Copyright © 2017 Sem Sturkenboom. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var createNameField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: SQLITE db
    private var db: Connection?
    
    var todoArray = [String]()
    let users = Table("users")
    let id = Expression<Int64>("id")
    let name = Expression<String>("name")
    
    @IBAction func storeInDatabase(_ sender: Any) {
        let insert = users.insert(name <- createNameField.text!)
        
        do {
            let rowId = try db!.run(insert)
            print(rowId)
            createTodoArray()
            tableView.reloadData()
            
        } catch {
            print("Error creating person:\(error)")
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatabase()
        createTodoArray()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todoItem = tableView.dequeueReusableCell(withIdentifier: "customcell") as! TableViewCell
        
        todoItem.toDo.text = todoArray[indexPath[1]]
        
        // Configure the cell...
        return todoItem
    }
    
    func setupDatabase() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do {
            db = try Connection("\(path)/db.sqlite3")
            print("setup database completed")
            createTable()
        } catch {
            // Error handling here.
            print("Cannot connect to database: \(error)")
        }
    }
    
    func createTable() {
        do {
            try db!.run(users.create(ifNotExists: true) { t in    // CREATE TABLE "users"
                t.column(id, primaryKey: true)                          // "id" INTEGER PRIMARY KEY NOT NULL,
                t.column(name)                                          //"name" TEXT
                print("created table")
            } )
        } catch {
            // Error handling
            print("Failed to create table: \(error)")
        }
    }
    
    func createTodoArray() {
        do {
            todoArray.removeAll()
            for todo in try db!.prepare(users) {
                if todo[name].isEmpty != true {
                    todoArray.append(todo[name])
                }
            }
        } catch {
            print("Unable to request data from database: \(error)")
        }
        
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let delete = users.filter(name == todoArray[indexPath.row])
            do {
                try db!.run(delete.delete())
                todoArray.remove(at: indexPath[1])
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                print("Unable to delete row: \(error)")
            }
        }
    }


}

