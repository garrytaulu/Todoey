//
//  ViewController.swift
//  Todoey
//
//  Created by Garry Taulu on 20/9/18.
//  Copyright © 2018 Garry Taulu. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var items = [Item]()

    // Get shared singleton object which is the current app as object
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        print(dataFilePath)
        
        loadItems()

    }
    
    
    //MARK: - Tableview Datasource Methods
    
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
    
    //MARK: - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        /*
        // Remove the item from the temporary context, call first cause we still need index
        context.delete(items[indexPath.row])
        
        // Remove item from just the UI
        items.remove(at: indexPath.row)
        
        */
        
        items[indexPath.row].done = !items[indexPath.row].done

        
        // Save everything then reload, always need this
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK: - Add new items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // what will happen once the user clicks add item button
            
            // print(textField.text)

            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
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
    
    //MARK: - Model Manipulation Methods
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    // 'with' is an external paramater and after equals is a default value?
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        do {
            items = try context.fetch(request)
        } catch {
            print("error here \(error)")
        }
        
        self.tableView.reloadData()

    }
    

}

//MARK: - Search bar methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
        
    }
    
    
}
