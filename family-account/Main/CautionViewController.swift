//--------------------------------------------------------------------------//
// Family Account - ViewController.swift
//
// Copyright 2021 shirajira <contact@novel-stud.io>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//--------------------------------------------------------------------------//

import UIKit

class CautionViewController: UIViewController {
    /// Repository url
    private let repositoryUrl: String = "https://github.com/shirajira/family-account-ios/"

    /// Presented `MainNavigation`?
    private var presentedMainNavigation: Bool = false

    // MARK: - Override Methods

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let delay: TimeInterval = 4.0 // [sec]
        presentMainNavigationWithDelay(delay: delay)
    }

    // MARK: - Actions

    @IBAction func tapScreen(_ sender: Any) {
        presentMainNavigation()
    }

    @IBAction func tapLinkToRepository(_ sender: Any) {
        openRepository(url: repositoryUrl)
    }

    private func presentMainNavigation() {
        guard let navigation = storyboard?.instantiateViewController(identifier: "MainNavigation") else {
            return
        }
        navigation.modalPresentationStyle = .overFullScreen
        navigation.modalTransitionStyle = .crossDissolve
        self.present(navigation, animated: true, completion: nil)

        presentedMainNavigation = true
    }

    private func presentMainNavigationWithDelay(delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if self.presentedMainNavigation {
                print("Canceled `presentMainNavigationWithDelay().`")
            } else {
                self.presentMainNavigation()
            }
        }
    }

    @discardableResult
    private func openRepository(url: String) -> Bool {
        guard let repository = URL(string: url) else {
            return false
        }
        UIApplication.shared.open(repository, options: [:], completionHandler: nil)
        return true
    }

}
