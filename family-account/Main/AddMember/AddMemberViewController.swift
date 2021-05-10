//--------------------------------------------------------------------------//
// Family Account - AddMemberViewController.swift
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

class AddMemberViewController: UIViewController, UITextFieldDelegate {
    /// FA manager
    private let faCoreManager = FACoreManager()

    /// Edit mode?
    private var editMode: Bool = false

    /// Target member (only used when edit mode)
    private var targetMember: FAMember? = nil

    /// Safe area
    private lazy var safeAreaInsets: UIEdgeInsets = {
        return view.safeAreaInsets
    }()

    @IBOutlet private weak var scrollView: TouchableScrollView!
    @IBOutlet private weak var errorMessage: UILabel!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var relationshipTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
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

    func setup(editMode: Bool, targetMember: FAMember?) {
        self.editMode = editMode
        self.targetMember = targetMember
    }

    private func setupTextFields() {
        nameTextField.delegate = self
        relationshipTextField.delegate = self
        emailTextField.delegate = self
        phoneNumberTextField.delegate = self

        if editMode, let member = targetMember {
            nameTextField.text = member.name
            relationshipTextField.text = member.relationship
            emailTextField.text = member.email
            phoneNumberTextField.text = member.phoneNumber
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
        navigationController?.popViewController(animated: true)
    }

    private func requestToSave() {
        if nameTextField.text!.isEmpty {
            showErrorMessage(enabled: true)
            return
        }

        if !editMode {
            addMember()
        } else {
            updateMember()
        }
        popViewController()
    }

    private func addMember() {
        var member = FAMember()
        member.filename = timestamp(format: "yyyyMMdd-HHmmss") + ".json"
        member.name = nameTextField.text!
        member.relationship = relationshipTextField.text!
        member.email = emailTextField.text!
        member.phoneNumber = phoneNumberTextField.text!
        faCoreManager.add(member: member)
    }

    private func updateMember() {
        guard var member = targetMember else {
            return
        }
        member.name = nameTextField.text!
        member.relationship = relationshipTextField.text!
        member.email = emailTextField.text!
        member.phoneNumber = phoneNumberTextField.text!
        faCoreManager.update(member: member)
    }

    private func showErrorMessage(enabled: Bool) {
        errorMessage.isHidden = !enabled
    }

    private func requestToDelete() {
        let alert = UIAlertController(title: "A", message: "B", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteMember()
            self.popViewController()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func deleteMember() {
        if let member = targetMember {
            faCoreManager.remove(member: member)
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
