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
        if AuthenticationManager.shared().readConfigurationFile(filename: "google_api.json") {
            if !AuthenticationManager.shared().canAuthorize() {
                self.startAuth()
            } else {
                log.verbose("Already have an access token \(AuthenticationManager.shared().accessToken)")
                self.listAlbums()
            }
        }
    }

    func startAuth() {

        let configuration = GTMAppAuthFetcherAuthorization.configurationForGoogle()
        let photoScope = OIDScopeUtilities.scopes(with: ["https://www.googleapis.com/auth/photoslibrary.readonly"])
        let scopes = [ OIDScopeOpenID, OIDScopeProfile, photoScope ]

        let request = OIDAuthorizationRequest(
            configuration: configuration,
            clientId: AuthenticationManager.shared().clientId!,
            clientSecret: AuthenticationManager.shared().clientSecret!,
            scopes: scopes,
            redirectURL: URL(string: AuthenticationManager.shared().redirectURL!)!,
            responseType: OIDResponseTypeCode,
            additionalParameters: nil)
        
        AuthenticationManager.shared().currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, callback: { (authState, error) in
            if let state = authState {
                let authorization = GTMAppAuthFetcherAuthorization(authState: state)
                AuthenticationManager.shared().setAuthorization(auth: authorization)

                self.listAlbums()
            } else {
                AuthenticationManager.shared().setAuthorization(auth: nil)
                if let responseError = error {
                    log.error(responseError)
                }
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
