//
//  HomeViewController.swift
//  DrawBerry
//
//  Created by Calvin Chen on 11/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    @IBOutlet private weak var background: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeElements()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Authentication.delegate = self
    }

    /// Hides the status bar at the top
    override var prefersStatusBarHidden: Bool {
        return true
    }

    func initializeElements() {
        background.image = Constants.mainMenuBackground
        background.alpha = Constants.backgroundAlpha
    }

    @IBAction private func handleLogOutButtonTapped(_ sender: UIButton) {
        Authentication.signOut()
    }

    func goToLoginScreen() {
        let loginViewController = storyboard?.instantiateViewController(identifier: "LoginVC") as? LoginViewController

        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
    }
}

extension HomeViewController: AuthenticationUpdateDelegate {

    func handleAuthenticationUpdate(status: Bool) {
        if status {
            goToLoginScreen()
        }
    }
}
