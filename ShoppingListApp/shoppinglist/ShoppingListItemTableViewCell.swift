//
//  ShoppingListItemTableViewCell.swift
//  ShoppingListApp
//
//  Created by Carsten W. Rose on 12.10.17.
//  Copyright © 2017 Carsten W. Rose. All rights reserved.
//

import UIKit

class ShoppingListItemTableViewCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var shoppingListItemTitleLabel: UILabel!
    @IBOutlet weak var shoppingListItemDescriptionLabel: UILabel!
    @IBOutlet weak var shoppingListItemCheckedSwitch: UISwitch!

    // MARK: - UITableViewCell
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Private Methods
    private func loadShoppingListItems() {
        
    }
}
