//
//  AddItemTableViewControllerDelegate.swift
//  BucketList
//
//  Created by Kaan Kabalak on 7/10/17.
//  Copyright © 2017 Kaan Kabalak. All rights reserved.
//

import Foundation

protocol AddItemTableViewControllerDelegate: class {
    func itemSaved(by controller: AddItemTableViewController, with text: String, at indexPath: NSIndexPath?)
    func cancelButtonPressed(by controller: AddItemTableViewController)
}
