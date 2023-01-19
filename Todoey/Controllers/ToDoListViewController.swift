//
//  ViewController.swift
//  Todoey
//
//  Created by Yedige Ashirbek on 17.12.2022.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadItems()
    }
    
    //MARK: - TableView DataSource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[(indexPath.row)]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemPrototypeCell", for: indexPath)
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done == true ? .checkmark : .none
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        var textField = UITextField()
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            if textField.text != "" {
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                self.itemArray.append(newItem)
                self.saveItems()
            }
        }
        let action1 = UIAlertAction(title: "Cancel", style: .default)
        alert.addAction(action)
        alert.addAction(action1)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
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
    
    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error loading context \(error)")
        }
        self.tableView.reloadData()
    }
}

extension ToDoListViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        if searchBar.text != "" {
//            let request: NSFetchRequest<Item> = Item.fetchRequest()
//            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//            request.predicate = predicate
//            let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//            request.sortDescriptors = [sortDescriptor]
//            do {
//                itemArray = try context.fetch(request)
//            } catch {
//                print("Error loading context \(error)")
//            }
//            self.tableView.reloadData()
//        }
//    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        if (searchBar.text?.count != 0){
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.predicate = predicate
        }
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error loading context \(error)")
        }
        self.tableView.reloadData()
        if (searchBar.text?.count == 0){
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
