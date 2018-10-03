//
//  ViewController.swift
//  Todoey
//
//  Created by Garry Taulu on 20/9/18.
//  Copyright © 2018 Garry Taulu. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var items = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        print(dataFilePath)

        loadItems()

    }
    
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // Ternary operator: value = condition ? valueIfTrue: valueIfFalse
        cell.accessoryType = item.done == true ? .checkmark : .none

        
        return cell
        
    }
    
    //MARK - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        items[indexPath.row].done = !items[indexPath.row].done
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        self.saveItems()

        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
    
    //MARK - Add new items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks add item button
//            print(textField.text)
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.items.append(newItem)
            
            self.saveItems()
    
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Item Name"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    //MARK - Model Manipulation Methods
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([Item].self, from: data)
            } catch {
                print("error decoding \(error)")
            }
        }
    }
    
}

