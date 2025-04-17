//
//  Base64.swift
//  ShoppingListApp
//
//  Created by Carsten W. Rose on 14.10.17.
//  Copyright © 2017 Carsten W. Rose. All rights reserved.
//

import Foundation
import SwiftyJSON

extension String {
    //: ### Base64 encoding a string
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    //: ### Base64 decoding a string
    func base64Decoded() -> String? {
        if let data = Data.init(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    //: ### Base64 URL encoding a string
    func base64URLEncoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64URLEncodedString()
        }
        return nil
    }
    
    //: ### Base64 URL decoding a string
    func base64URLDecoded() -> String? {
        if let data = Data.init(base64URLEncoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}

extension Data {
    
    init?(base64URLEncoded string: String) {
        let base64Encoded = string
            .replacingOccurrences(of: "_", with: "/")
            .replacingOccurrences(of: "-", with: "+")
        // iOS can't handle base64 encoding without padding. Add manually
        let padLength = (4 - (base64Encoded.count % 4)) % 4
        let base64EncodedWithPadding = base64Encoded + String(repeating: "=", count: padLength)
        self.init(base64Encoded: base64EncodedWithPadding)
    }

    
    func base64URLEncodedString() -> String {
        // use URL safe encoding and remove padding
        return self.base64EncodedString()
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "=", with: "")
    }
}

class JWT {
    
    var header: String?
    var claims: String?
    var signature: String?
    
    init(forToken token: String) {
        var components = token.components(separatedBy: ".")
        header = components[0]
        claims = components[1]
        signature = components[2]
    }
    
    func string(forClaim claim: String) -> String? {
        guard let data = Data(base64URLEncoded: claims!) else {
            debugPrint("no id token")
            return nil
        }
        let jsonData = JSON(data)
        return jsonData[claim].string
    }
}
