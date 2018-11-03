//
//  AuthenticationHelper.swift
//
//  Created by Wim Haanstra on 31/10/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//
import Foundation
import Alamofire
import GTMAppAuth

class AuthenticationHelper {
    private static var sharedAuthenticationHelper: AuthenticationHelper = {
        let manager = AuthenticationHelper()
        return manager
    }()

    var clientId: String?
    var clientSecret: String?
    var redirectUrl: String?

    private init() {
        // _ = self.readConfigurationFile(filename: "google_api.json")
    }

    class func shared() -> AuthenticationHelper {
        return self.sharedAuthenticationHelper
    }

    public var currentAuthorizationFlow: OIDAuthorizationFlowSession?
    private var authorization: GTMAppAuthFetcherAuthorization?

    /// Storage authentication information, for later use
    ///
    /// - Parameter auth: The authentication information retrieved from Google OAuth endpoint
    func setAuthorization(auth: GTMAppAuthFetcherAuthorization?) {
        self.authorization = auth

        if let accessToken = self.authorization?.authState.lastTokenResponse?.accessToken {
            log.verbose("Got an access token! \(accessToken)")
        }
    }

    /// Creates a header with the current OAuth access token from Google
    ///
    /// - Returns: A HTTPHeaders object, containing an Authorization header
    func authorizationHeader() -> HTTPHeaders {
        if let accessToken = self.authorization?.authState.lastTokenResponse?.accessToken {
            let headers: HTTPHeaders = [
                "Authorization": "Bearer " + accessToken
            ]
            return headers
        } else {
            return [:]
        }
    }

    func readConfigurationFile(filename: String) -> Bool {
        if let path = Bundle.main.path(forResource: filename, ofType: nil) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? Dictionary<String, AnyObject> {
                    self.clientId = jsonResult["client_id"] as? String
                    self.clientSecret = jsonResult["client_secret"] as? String
                    self.redirectUrl = jsonResult["redirect_url"] as? String
                }
                return true
            } catch {
                log.error("Could not serialize with file '\(filename)', file in correct format?")
                return false
            }
        } else {
            log.error("Could not initialize with file '\(filename)', file exists?")
            return false
        }
    }

    func googleKeyFromFile() -> String {
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
