//
//  NetworkShoppingListDataSource.swift
//  ShoppingListApp
//
//  Created by Carsten W. Rose on 14.10.17.
//  Copyright © 2017 Carsten W. Rose. All rights reserved.
//

import UIKit
import Alamofire
import BrightFutures

protocol ShoppingListDataSource {
    
    func readAllShoppingLists() -> Future<[ShoppingList], AuthenticationError>
    
    func readShoppingListItems(shoppingList: ShoppingList) -> Future<[ShoppingListItem], AuthenticationError>
}

class NetworkShoppingListDataSource: ShoppingListDataSource {
    
    var authorizationKeyChain = AuthorizationKeychain()
    
    func readAllShoppingLists() -> Future<[ShoppingList], AuthenticationError> {

        let response = Promise<[ShoppingList], AuthenticationError>()

        request { (userId, headers) in

            Alamofire.request("https://shoppinglist-test.cwrose.de/api/users/\(String(describing: userId))/shopping-list", headers: headers)
                .validate(statusCode: [200])
                .responseData { dataResponse in
                    guard let data = dataResponse.data, dataResponse.error == nil else {
                        debugPrint("Error: \(dataResponse.error!)")
                        response.failure(.unauthorized)
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    let shoppingListResponse = try! decoder.decode([ShoppingList].self, from: data)
                    response.success(shoppingListResponse)
            }
        }
        
        return response.future
    }
    
    func readShoppingListItems(shoppingList: ShoppingList) -> Future<[ShoppingListItem], AuthenticationError> {
        
        let response = Promise<[ShoppingListItem], AuthenticationError>()
        
        request { (userId, headers) in
            
            let url = "https://shoppinglist-test.cwrose.de/api/users/\(String(describing: userId))/shopping-list/\(String(describing: shoppingList.shoppingListId))/entries"
            Alamofire.request(url, headers: headers)
                .validate(statusCode: [200])
                .responseData { dataResponse in
                    guard let data = dataResponse.data, dataResponse.error == nil else {
                        debugPrint("Error: \(dataResponse.error!)")
                        response.failure(.unauthorized)
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    let shoppingListItemsResponse = try! decoder.decode([ShoppingListItem].self, from: data)
                    response.success(shoppingListItemsResponse)
            }
        }
        
        
        return response.future
    }
    
    func request(requestCall closure: (_ userId: String, _ headers: HTTPHeaders) -> Void) {
        guard let authToken = authorizationKeyChain.read(forKey: .authToken) else {
            fatalError("No auth token found. I don't know how you have come so far")
        }
        
        guard let idToken = authorizationKeyChain.read(forKey: .idToken) else {
            fatalError("No id token found. I don't know how you have come so far")
        }
        
        guard let userId = JWT(forToken: idToken).string(forClaim: "id") else {
            fatalError("No userId in token.")
        }
        
        let headers = createDefaultHeader(forToken: authToken)

        closure(userId, headers)
    }
    
    private func createDefaultHeader(forToken authToken: String) -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            "Authorization": "Bearer \(authToken)"
        ]
        return headers
    }
}
