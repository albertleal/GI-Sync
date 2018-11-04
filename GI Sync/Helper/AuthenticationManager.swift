//
//  AuthenticationHelper.swift
//
//  Created by Wim Haanstra on 31/10/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//
import Foundation
import Alamofire
import GTMAppAuth

class AuthenticationManager {
    private static var sharedAuthenticationManager: AuthenticationManager = {
        let manager = AuthenticationManager()
        return manager
    }()

    private init() {
        self.loadState()
    }

    class func shared() -> AuthenticationManager {
        return self.sharedAuthenticationManager
    }

    public var authorization: GTMAppAuthFetcherAuthorization?

    public var currentAuthorizationFlow: OIDAuthorizationFlowSession?

    /// ClientId for Google API
    public var clientId: String?

    /// Client secret for Google API
    public var clientSecret: String?

    /// Redirect URL for Google API, client ID reversed with :/oauthredirect appended
    var redirectURL: String? {
        if let clientId = self.clientId {
            var parts = clientId.split(separator: ".")
            parts.reverse()
            let result = parts.joined(separator: ".")
            return "\(result):/oauthredirect"
        }
        return nil
    }

    /// Current access token, when available
    var accessToken: String? {
        return self.authorization?.authState.lastTokenResponse?.accessToken
    }

    /// Store the current authentication state in the keychain
    func saveState() {
        if let authorize = self.authorization, authorize.canAuthorize() {
            GTMAppAuthFetcherAuthorization.removeFromKeychain(forName: "authorization")
            GTMAppAuthFetcherAuthorization.save(authorize, toKeychainForName: "authorization")
        } else {
            GTMAppAuthFetcherAuthorization.removeFromKeychain(forName: "authorization")
        }
    }

    /// Load the previous authentication state from the keychain
    func loadState() {
        let authorization = GTMAppAuthFetcherAuthorization(fromKeychainForName: "authorization")
        self.setAuthorization(auth: authorization)
    }

    /// Check if currently stored authentication info is valid
    ///
    /// - Returns: True when it should work, false otherwise
    func canAuthorize() -> Bool {
        if let authorize = self.authorization,
            let expireDate = authorize.authState.lastTokenResponse?.accessTokenExpirationDate,
            authorize.canAuthorize(),
            expireDate > Date() {

            return true

        }
        return false
    }

    /// Storage authentication information, for later use
    ///
    /// - Parameter auth: The authentication information retrieved from Google OAuth endpoint
    func setAuthorization(auth: GTMAppAuthFetcherAuthorization?) {
        self.authorization = auth
        self.saveState()
    }

    /// Creates a header with the current OAuth access token from Google
    ///
    /// - Returns: A HTTPHeaders object, containing an Authorization header
    func authorizationHeader() -> HTTPHeaders {
        if let accessToken = self.accessToken {
            let headers: HTTPHeaders = [
                "Authorization": "Bearer " + accessToken
            ]
            return headers
        } else {
            return [:]
        }
    }

    /// Reads Google API configuration from a JSON file
    /// expects client_id and client_secret in the JSON object
    ///
    /// - Parameter filename: The filename to load
    /// - Returns: True if loading went fine, otherwise false
    func readConfigurationFile(filename: String) -> Bool {
        if let path = Bundle.main.path(forResource: filename, ofType: nil) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? Dictionary<String, AnyObject> {
                    self.clientId = jsonResult["client_id"] as? String
                    self.clientSecret = jsonResult["client_secret"] as? String
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
}
