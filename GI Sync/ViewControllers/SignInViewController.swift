//
//  SignInViewController.swift
//  GI Sync
//
//  Created by Wim Haanstra on 03/11/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//

import Foundation
import AppKit
import GTMAppAuth

class SigninViewController : NSViewController {

    override func loadView() {
        self.view = NSView()
    }

    override func viewDidLoad() {
        if AuthenticationHelper.shared().readConfigurationFile(filename: "google_api.json") {
            log.verbose(AuthenticationHelper.shared().clientId)
            log.verbose(AuthenticationHelper.shared().redirectURL)
            self.startAuth()
        }
    }

    func startAuth() {

        let configuration = GTMAppAuthFetcherAuthorization.configurationForGoogle()
        let photoScope = OIDScopeUtilities.scopes(with: ["https://www.googleapis.com/auth/photoslibrary.readonly"])
        let scopes = [ OIDScopeOpenID, OIDScopeProfile, photoScope ]

        let request = OIDAuthorizationRequest(
            configuration: configuration,
            clientId: AuthenticationHelper.shared().clientId!,
            clientSecret: AuthenticationHelper.shared().clientSecret!,
            scopes: scopes,
            redirectURL: URL(string: AuthenticationHelper.shared().redirectURL!)!,
            responseType: OIDResponseTypeCode,
            additionalParameters: nil)
        
        AuthenticationHelper.shared().currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, callback: { (authState, error) in
            if let state = authState {
                let authorization = GTMAppAuthFetcherAuthorization(authState: state)
                AuthenticationHelper.shared().setAuthorization(auth: authorization)

                self.listAlbums()
            } else {
                AuthenticationHelper.shared().setAuthorization(auth: nil)
                log.error(error)
            }
        })
    }

    func listAlbums() {
        Album.listAll(completed: { (albums) in
            log.verbose("Found \(albums.count)")
        }) { (error) in
            log.error(error)
        }
    }
}
