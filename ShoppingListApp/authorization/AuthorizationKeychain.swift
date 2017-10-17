//
//  AuthenticationKeychain.swift
//  ShoppingListApp
//
//  Created by Carsten W. Rose on 14.10.17.
//  Copyright © 2017 Carsten W. Rose. All rights reserved.
//

import SwiftKeychainWrapper
import os.log

enum AuthorizationToken: String {
    case authToken, idToken
}

protocol AuthorizationKeyChainProtocol {
    
    func store(authData: AuthorizationData)
    
    func read(forKey: AuthorizationToken) -> String?
}

class AuthorizationKeychain: AuthorizationKeyChainProtocol {

    
    func store(authData: AuthorizationData) {
        debugPrint("save authData: \(authData)")
        KeychainWrapper.standard.set(authData.authToken, forKey: AuthorizationToken.authToken.rawValue)
        KeychainWrapper.standard.set(authData.idToken, forKey: AuthorizationToken.idToken.rawValue)
        KeychainWrapper.standard.set(authData.expires, forKey: "EXPIRES")
    }
    
    func read(forKey token: AuthorizationToken) -> String? {
        let value = KeychainWrapper.standard.string(forKey: token.rawValue)
        debugPrint("found token \(String(describing: value)) for key \(token.rawValue)")
        return value
    }
}
