//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Yedige Ashirbek on 19.01.2023.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoriesArray = [Categories]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategories()
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
     
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categories = categoriesArray[(indexPath.row)]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesPrototypeCell", for: indexPath)
        cell.textLabel?.text = categories.name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoriesArray[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func loadCategories(){
        let request: NSFetchRequest<Categories> = Categories.fetchRequest()
        do {
            categoriesArray = try context.fetch(request)
        } catch{
            print("Error loading context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func saveCategories(){
        do {
            try context.save()
        } catch{
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        var textField = UITextField()
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            if textField.text != "" {
                let newCategories = Categories(context: self.context)
                newCategories.name = textField.text!
                self.categoriesArray.append(newCategories)
                self.saveCategories()
            }
        }
        let action1 = UIAlertAction(title: "Cancel", style: .default)
        alert.addAction(action)
        alert.addAction(action1)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
}
