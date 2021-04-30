//--------------------------------------------------------------------------//
// Family Account - MembersViewController.swift
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

class MembersViewController: UIViewController {

    // MARK: - Override Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }

    // MARK: - Setup Methods

    private func setupNavigationBar() {
        if let navigation = navigationController {
            navigation.navigationBar.barTintColor = .mainAccent
            navigation.navigationBar.isTranslucent = false
            navigation.navigationBar.tintColor = .mainWhite
            navigation.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.mainWhite]
            navigation.navigationBar.shadowImage = UIImage()
        }
    }

}
