//
//  AddItemTableViewController.swift
//  BucketList
//
//  Created by Kaan Kabalak on 7/10/17.
//  Copyright © 2017 Kaan Kabalak. All rights reserved.
//

import UIKit

class AddItemTableViewController: UITableViewController {
    
    @IBOutlet weak var itemTextField: UITextField!
    weak var delegate: AddItemTableViewControllerDelegate?
    var item: String?
    var indexPath: NSIndexPath?
    
    @IBAction func CancelButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.cancelButtonPressed(by: self)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let text = itemTextField.text!
        delegate?.itemSaved(by: self, with: text, at: indexPath)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTextField.text = item
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
