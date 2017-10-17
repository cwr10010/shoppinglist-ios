//
//  ShoppingList.swift
//  ShoppingListApp
//
//  Created by Carsten W. Rose on 14.10.17.
//  Copyright © 2017 Carsten W. Rose. All rights reserved.
//

import UIKit

struct ShoppingList: Codable {

    var shoppingListId: String
    var shoppingListName: String
    var ownersId: String
    var ownersName: String
    
    enum CodingKeys: String, CodingKey {
        case shoppingListId = "shopping_list_id"
        case shoppingListName = "shopping_list_name"
        case ownersId = "owners_id"
        case ownersName = "owners_name"
    }
}
