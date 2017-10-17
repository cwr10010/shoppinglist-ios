//
//  NetworkLoginDataSource.swift
//  ShoppingListApp
//
//  Created by Carsten W. Rose on 12.10.17.
//  Copyright © 2017 Carsten W. Rose. All rights reserved.
//

import UIKit
import os.log
import Alamofire
import SwiftyJSON
import BrightFutures

// MARK: - Interface
public enum AuthenticationError: Error {
    case unknownError
    case unauthorized
}

protocol AuthenticationDataSource {
    
    func doLogin(loginData: LoginData) -> Future<AuthorizationData, AuthenticationError>
    
    func refresh(forToken authToken: String) -> Future<AuthorizationData, AuthenticationError>
}

// MARK: - Implementation
class NetworkAuthenticationDataSource: AuthenticationDataSource {

    // MARK: - Properties
    
    let shoppingListAuthUrl: String = "https://shoppinglist-test.cwrose.de/api/auth"
    
    // MARK: - Login
    
    func doLogin(loginData: LoginData) -> Future<AuthorizationData, AuthenticationError> {
        let headers = createDefaultHeader()
        let encoder = JSONEncoder()
        let parameters = try! encoder.encode(loginData)
        
        let response = Promise<AuthorizationData, AuthenticationError>()
        Alamofire.request(shoppingListAuthUrl, method: .post, parameters: JSON(parameters).dictionaryObject, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: [200])
            .responseData { dataResponse in
            
            guard let data = dataResponse.data, dataResponse.error == nil else {
                debugPrint("Login failed: \(String(describing: dataResponse.error))")
                response.failure(.unauthorized)
                return
            }
            
            response.success(self.decodeAuthorizationData(from: data))
        }
        return response.future
    }
    
    // MARK: - Refresh
    
    func refresh(forToken authToken: String) -> Future<AuthorizationData, AuthenticationError> {
        var headers = createDefaultHeader()
        headers.updateValue("Bearer \(authToken)", forKey: "Authorization")
        
        let response = Promise<AuthorizationData, AuthenticationError>()
        Alamofire.request(shoppingListAuthUrl, headers:headers)
            .validate(statusCode: [200])
            .responseData { dataResponse in
                
                guard let data = dataResponse.data, dataResponse.error == nil else {
                    debugPrint("Refresh failed: \(String(describing: dataResponse.error))")
                    response.failure(.unauthorized)
                    return
                }
                
                response.success(self.decodeAuthorizationData(from: data))
        }
        return response.future
    }
    
    // MARK: - Private Functions

    private func createDefaultHeader() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "content-type": "application/json"
        ]
        return headers
    }

    private func decodeAuthorizationData(from data: Data) -> AuthorizationData {
        let decoder = JSONDecoder()
        return try! decoder.decode(AuthorizationData.self, from: data)
    }
}
