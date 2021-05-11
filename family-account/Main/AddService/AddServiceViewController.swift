//--------------------------------------------------------------------------//
// Family Account - AddServiceViewController.swift
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

class AddServiceViewController: UIViewController, UITextFieldDelegate {
    /// FA manager
    private let faCoreManager = FACoreManager()

    /// Target member
    private var targetMember = FAMember()

    /// Edit mode?
    private var editMode: Bool = false

    /// Target service index (only used when edit mode)
    private var targetServiceIndex: Int = -1

    /// Safe area
    private lazy var safeAreaInsets: UIEdgeInsets = {
        return view.safeAreaInsets
    }()

    @IBOutlet private weak var scrollView: TouchableScrollView!
    @IBOutlet private weak var errorMessage: UILabel!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var accountTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var dangerOperationView: UIView!

    // MARK: - Override Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextFields()
        setupDeleteButton()
        setupKeyboardObserver()

        showErrorMessage(enabled: false)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // MARK: - Setup Methods

    func setup(targetMember: FAMember, editMode: Bool, targetServiceIndex: Int) {
        self.targetMember = targetMember
        self.editMode = editMode
        self.targetServiceIndex = targetServiceIndex
    }

    private func setupTextFields() {
        nameTextField.delegate = self
        accountTextField.delegate = self
        passwordTextField.delegate = self

        if editMode {
            print("Index = \(targetServiceIndex)")
            if targetServiceIndex >= 0, targetServiceIndex < targetMember.services.count {
                let service = targetMember.services[targetServiceIndex]
                nameTextField.text = service.name
                accountTextField.text = service.account
                passwordTextField.text = service.password
            }
        }
    }

    private func setupDeleteButton() {
        if !editMode {
            dangerOperationView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            dangerOperationView.isHidden = true
        } else {
            dangerOperationView.isHidden = false
        }
    }

    private func setupKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    // MARK: - Actions

    @IBAction func tapSave(_ sender: Any) {
        requestToSave()
    }

    @IBAction func tapDelete(_ sender: Any) {
        requestToDelete()
    }

    private func popViewController() {
        if !editMode {
            navigationController!.popViewController(animated: true)
        } else {
            let index = navigationController!.viewControllers.count - 3
            navigationController!.popToViewController(navigationController!.viewControllers[index], animated: true)
        }
    }

    private func requestToSave() {
        if nameTextField.text!.isEmpty {
            showErrorMessage(enabled: true)
            return
        }

        if !editMode {
            addService()
        } else {
            updateService()
        }
        popViewController()
    }

    private func addService() {
        var service = FAService()
        service.name = nameTextField.text!
        service.account = accountTextField.text!
        service.password = passwordTextField.text!

        let currentTime = timestamp(format: "yyyy-MM-dd HH:mm:ss")
        service.created = currentTime
        service.updated = currentTime

        targetMember.services.append(service)
        sortServices()
        faCoreManager.update(member: targetMember)
    }

    private func updateService() {
        var targetService = targetMember.services[targetServiceIndex]
        targetService.name = nameTextField.text!
        targetService.account = accountTextField.text!
        targetService.password = passwordTextField.text!

        let currentTime = timestamp(format: "yyyy-MM-dd HH:mm:ss")
        targetService.updated = currentTime

        targetMember.services[targetServiceIndex] = targetService
        sortServices()
        faCoreManager.update(member: targetMember)
    }

    private func showErrorMessage(enabled: Bool) {
        errorMessage.isHidden = !enabled
    }

    private func requestToDelete() {
        let alert = UIAlertController(title: "A", message: "B", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteService()
            self.popViewController()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func deleteService() {
        targetMember.services.remove(at: targetServiceIndex)
        sortServices()
        faCoreManager.update(member: targetMember)
    }

    private func sortServices() {
        targetMember.services.sort { (lhService, rhService) -> Bool in
            return lhService.name < rhService.name
        }
    }

    // MARK: - Delegate Methods (UITextFieldDelegate)

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: - Keyboard Controls

    @objc
    private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else {
            return
        }
        guard let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardInfo.cgRectValue.height - safeAreaInsets.bottom, right: 0)
        UIView.animate(
            withDuration: duration,
            animations: {
                self.scrollView.contentInset = contentInsets
                self.scrollView.scrollIndicatorInsets = contentInsets
            }
        )
    }

    @objc
    private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else {
            return
        }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        UIView.animate(
            withDuration: duration,
            animations: {
                self.scrollView.contentInset = .zero
                self.scrollView.scrollIndicatorInsets = .zero
            }
        )
    }

}
