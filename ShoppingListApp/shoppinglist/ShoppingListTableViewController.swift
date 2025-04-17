//
//  ShoppingListTableViewController.swift
//  ShoppingListApp
//
//  Created by Carsten W. Rose on 14.10.17.
//  Copyright © 2017 Carsten W. Rose. All rights reserved.
//

import UIKit

class ShoppingListTableViewController: UITableViewController {

    // MARK: - Properties
    var authorizationKeychain = AuthorizationKeychain()
    
    var authenticationDataSource = NetworkAuthenticationDataSource()
    
    var shoppingListDataSource = NetworkShoppingListDataSource()
    
    var shoppingListItems: [ShoppingListItem] = []
    
    var shoppingLists: [ShoppingList] = []
    
    var currentShoppingList: ShoppingList?
    
    // MARK: - UITableViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let authToken = authorizationKeychain.read(forKey: .authToken) else {
            self.showLoginDialog()
            return
        }
        
        authenticationDataSource.refresh(forToken: authToken)
            .onFailure { error in
                self.showLoginDialog()
            }.onSuccess { authData in
                self.authorizationKeychain.store(authData: authData)
                
                self.loadShoppingLists {
                     self.tableView.reloadData()
                }
            }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugPrint("number of rows: \(shoppingListItems.count)")
        return self.shoppingListItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ShoppingListItemTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ShoppingListItemTableViewCell else {
            fatalError("The dequeued cell was not an instance of ShoppingListItemTableViewCell.")
        }
        
        let item = shoppingListItems[indexPath.row]
        debugPrint("configuring row number \(indexPath.row) for item \(String(describing: item.name))")

        cell.shoppingListItemTitleLabel.text = item.name
        cell.shoppingListItemDescriptionLabel.text = item.description
        cell.shoppingListItemCheckedSwitch.isOn = item.checked!

        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Private Methods
    
    private func showLoginDialog() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.present(storyboard.instantiateViewController(withIdentifier: "loginViewController"), animated: true, completion: nil)
    }
    
    private func loadShoppingLists(closure: @escaping () -> Void) {
        self.shoppingListDataSource.readAllShoppingLists()
            .onFailure { error in
                debugPrint("Failed updating shopping lists: \(error)")
            }.onSuccess { lists in
                self.shoppingLists = lists
                self.currentShoppingList = lists.first
                
                guard let shoppingList = self.currentShoppingList else {
                    debugPrint("no shopping list available")
                    return
                }
                
                self.loadShoppingListItems(shoppingList: shoppingList) {
                    closure()
                }
        }
    }
    
    private func loadShoppingListItems(shoppingList: ShoppingList, closure: @escaping () -> Void) {
        
        self.shoppingListDataSource.readShoppingListItems(shoppingList: shoppingList)
            .onFailure { error in
                debugPrint("Failed updating shopping list items: \(error)")
            }.onSuccess { items in
                self.shoppingListItems = items
                closure()
        }
    }
    
}
