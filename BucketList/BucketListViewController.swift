//
//  ViewController.swift
//  BucketList
//
//  Created by Kaan Kabalak on 7/10/17.
//  Copyright © 2017 Kaan Kabalak. All rights reserved.
//

import UIKit
import CoreData

class BucketListViewController: UITableViewController, AddItemTableViewControllerDelegate {

    var items = [BucketListItem]()
    
    // this is like a staging area
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAllItems(){
        TaskModel.getAllTasks() {
            data, response, error in
            do {
                if let tasks = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [NSDictionary] {
                    print(tasks)
                    for task in tasks {
                        let item = NSEntityDescription.insertNewObject(forEntityName: "BucketListItem", into: self.managedObjectContext) as! BucketListItem
                        print(task["objective"]!)
                        item.text = task["objective"]! as! String
                        self.items.append(item)
                        do {
                            try self.managedObjectContext.save()
                        } catch {
                            print("\(error)")
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print("Something went wrong")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].text!
        return cell
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "AddItemSegue", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        managedObjectContext.delete(item)
        
        do {
            try managedObjectContext.save()
        } catch {
            print("\(error)")
        }
        items.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = sender as? UIBarButtonItem {
            let navigationController = segue.destination as! UINavigationController
            let addItemTableViewController = navigationController.topViewController as! AddItemTableViewController
            addItemTableViewController.delegate = self
        } else {
            let navigationController = segue.destination as! UINavigationController
            let addItemTableViewController = navigationController.topViewController as! AddItemTableViewController
            addItemTableViewController.delegate = self
            
            let indexPath = sender as! NSIndexPath
            let item = items[indexPath.row]
            addItemTableViewController.item = item.text!
            addItemTableViewController.indexPath = indexPath
        }
        
    }
    
    // make request to db
    func fetchAllItems() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BucketListItem")
        do {
            let result = try managedObjectContext.fetch(request)
            items = result as! [BucketListItem]
        } catch {
            print("\(error)")
        }
        
    }
    
    func cancelButtonPressed(by controller: AddItemTableViewController) {
        print("I'm the hidden controller, BUT I am responding to the cancel button press on the top view controller")
        dismiss(animated: true, completion: nil)
    }
    
    func itemSaved(by controller: AddItemTableViewController, with text: String, at indexPath: NSIndexPath?) {
        if let ip = indexPath {
            let item = items[ip.row]
            item.text = text
        } else {
            TaskModel.addTaskWithObjective(objective: text) {
                data, response, error in
                
            }
        }
        
        let item = NSEntityDescription.insertNewObject(forEntityName: "BucketListItem", into: self.managedObjectContext) as! BucketListItem
        item.text = text
        self.items.append(item)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        
        dismiss(animated: true, completion: nil)
    }
}

