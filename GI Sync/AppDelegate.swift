//
//  AppDelegate.swift
//  GI Sync
//
//  Created by Wim Haanstra on 02/11/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//

import Cocoa
import GTMAppAuth

import SwiftyBeaver
let log = SwiftyBeaver.self

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    func applicationWillFinishLaunching(_ notification: Notification) {
        let console = ConsoleDestination()
        log.addDestination(console)

        NSAppleEventManager.shared().setEventHandler(
            self,
            andSelector: #selector(handleUrlEvent(_:with:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL))
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let viewController = SigninViewController(nibName: nil, bundle: nil)
        self.window.contentView = viewController.view
        self.window.makeKeyAndOrderFront(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

    @objc
    func handleUrlEvent(_ event: NSAppleEventDescriptor, with replyEvent: NSAppleEventDescriptor) {
        if let urlString = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue,
            let url = URL(string: urlString),
            let authorizationFlow = AuthenticationManager.shared().currentAuthorizationFlow
        {
            authorizationFlow.resumeAuthorizationFlow(with: url)
        }
    }
}

