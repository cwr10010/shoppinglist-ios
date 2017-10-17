//
//  AuthorizationResponse.swift
//  ShoppingListApp
//
//  Created by Carsten W. Rose on 11.10.17.
//  Copyright © 2017 Carsten W. Rose. All rights reserved.
//

import UIKit

struct AuthorizationData: Codable {
    var authToken: String
    var idToken: String
    var expires: Int
    
    enum CodingKeys: String, CodingKey {
        case authToken = "auth_token"
        case idToken = "id_token"
        case expires
    }
}
