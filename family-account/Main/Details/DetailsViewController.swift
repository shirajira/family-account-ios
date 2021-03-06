//--------------------------------------------------------------------------//
// Family Account - DetailsViewController.swift
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

class DetailsViewController: UIViewController {
    /// Target member
    private var targetMember = FAMember()

    /// Target service index
    private var targetServiceIndex: Int = -1

    /// Target service
    private var targetService = FAService()

    /// Show the password or not.
    private var showPasswordStatus: Bool = false

    /// Haptics feedback
    private let haptics = UIImpactFeedbackGenerator(style: .light)

    @IBOutlet private weak var serviceNameLabel: UILabel!
    @IBOutlet private weak var accountLabel: UILabel!
    @IBOutlet private weak var passwordLabel: UILabel!
    @IBOutlet private weak var showPasswordButton: UIButton!
    @IBOutlet private weak var notesLabel: UILabel!
    @IBOutlet private weak var createdLabel: UILabel!
    @IBOutlet private weak var updatedLabel: UILabel!

    // MARK: - Override Methods

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateDetails()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditService" {
            if let addServiceViewController = segue.destination as? AddServiceViewController {
                addServiceViewController.setup(targetMember: targetMember, editMode: true, targetServiceIndex: targetServiceIndex)
            }
        }
    }

    // MARK: - Setup Methods

    func setup(targetMember: FAMember, targetServiceIndex: Int) {
        self.targetMember = targetMember
        self.targetServiceIndex = targetServiceIndex

        self.targetService = self.targetMember.services[self.targetServiceIndex]
    }

    private func updateDetails() {
        serviceNameLabel.text = targetService.name
        accountLabel.text = targetService.account
        passwordLabel.text = mask(password: targetService.password)
        notesLabel.text = targetService.notes
        createdLabel.text = targetService.created
        updatedLabel.text = targetService.updated
    }

    private func mask(password: String) -> String {
        var masked: String = ""
        for _ in 0 ..< password.count {
            masked += "*"
        }
        return masked
    }

    // MARK: - Actions

    @IBAction func tapEye(_ sender: Any) {
        if !showPasswordStatus {
            // Switch to show the password.
            showPasswordStatus = true
            showPassword()
        } else {
            // Switch to hide the password.
            showPasswordStatus = false
            hidePassword()
        }
        playHaptics()
    }

    private func showPassword() {
        let eyeClosed = UIImage(named: "EyeClosed")
        showPasswordButton.setImage(eyeClosed, for: .normal)
        passwordLabel.text = targetService.password
    }

    private func hidePassword() {
        let eyeOpened = UIImage(named: "Eye")
        showPasswordButton.setImage(eyeOpened, for: .normal)
        passwordLabel.text = mask(password: targetService.password)
    }

    private func playHaptics() {
        haptics.prepare()
        haptics.impactOccurred()
    }

}
