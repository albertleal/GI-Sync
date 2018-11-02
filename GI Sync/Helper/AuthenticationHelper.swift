//
//  AuthenticationHelper.swift
//
//  Created by Wim Haanstra on 31/10/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//

import Alamofire

class AuthenticationHelper {

    /// Creates a header with the current OAuth access token from Google
    ///
    /// - Returns: A HTTPHeaders object, containing an Authorization header
    static func authorizationHeader() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + "GIDSignIn.sharedInstance().currentUser.authentication.accessToken"
        ]
        return headers
    }

    static func googleKeyFromFile() -> String {
        do {
            if let url = Bundle.main.url(forResource: "google.apikey", withExtension: nil) {
                let key = try String(contentsOf: url, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
                return key
            }
        } catch {
        }
        log.error("Could not get Google API key, make sure 'google.apikey' exists and contains your Google API key")
        return ""
    }
}
