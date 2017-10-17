//
//  ShoppingListItem.swift
//  ShoppingListApp
//
//  Created by Carsten W. Rose on 12.10.17.
//  Copyright © 2017 Carsten W. Rose. All rights reserved.
//

class ShoppingListItem: Codable {
    
    // MARK: Properties
    
    var id: String
    var name: String
    var description: String
    var order: Int
    var checked: Bool
    
}

