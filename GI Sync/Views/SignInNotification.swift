//
//  SignInNotification.swift
//  GI Sync
//
//  Created by Wim Haanstra on 04/11/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//

import AppKit
import PureLayout

class SignInNotificationView: NSView {

    var signInButton = NSButton(title: "Sign in", target: self, action: #selector(signInButtonClicked))
    var signInMessage = NSTextView(forAutoLayout: ())

    override func viewDidMoveToWindow() {
        self.addSubview(self.signInButton)
        self.signInButton.autoPinEdgesToSuperviewEdges(with: NSEdgeInsetsZero, excludingEdge: .left)
        self.signInButton.autoSetDimension(.width, toSize: 150)

        self.addSubview(self.signInMessage)
        self.signInMessage.autoPinEdgesToSuperviewEdges(with: NSEdgeInsetsZero, excludingEdge: .right)
        self.signInMessage.autoPinEdge(.right, to: .left, of: self.signInButton)
        self.signInMessage.textStorage?.append(NSAttributedString(string: "You should sign in"))
    }

    @objc
    func signInButtonClicked() {
        log.verbose("Trying to sign in")
    }
}
