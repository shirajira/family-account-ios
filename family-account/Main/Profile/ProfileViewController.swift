//--------------------------------------------------------------------------//
// Family Account - ProfileViewController.swift
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

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    /// FA manager
    private let faCoreManager = FACoreManager()

    /// Target member
    private var targetMember = FAMember()

    /// Target service
    private var targetServiceIndex: Int = -1

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var relationshipLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var phoneNumberLabel: UILabel!
    @IBOutlet private weak var serviceCollectionView: UICollectionView!
    @IBOutlet private weak var emptyGuideLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateProfile()
        updateServiceList()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddService" {
            if let addServiceViewController = segue.destination as? AddServiceViewController {
                addServiceViewController.setup(targetMember: targetMember, editMode: false, targetServiceIndex: -1)
            }
        } else if segue.identifier == "toDetails" {
            if let detailsViewController = segue.destination as? DetailsViewController {
                detailsViewController.setup(targetMember: targetMember, targetServiceIndex: targetServiceIndex)
            }
        } else if segue.identifier == "toEditMember" {
            if let addMemberViewController = segue.destination as? AddMemberViewController {
                addMemberViewController.setup(editMode: true, targetMember: targetMember)
            }
        }
    }

    // MARK: - Setup Methods

    func setup(member: FAMember) {
        targetMember = member
    }

    private func setupCollectionView() {
        serviceCollectionView.register(
            UINib(nibName: "ServiceCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "ServiceCollectionViewCell"
        )
        serviceCollectionView.delegate = self
        serviceCollectionView.dataSource = self
    }

    // MARK: - Update Methods

    private func updateProfile() {
        nameLabel.text = targetMember.name
        relationshipLabel.text = targetMember.relationship
        setEmailLabel(targetMember.email)
        setPhoneNumberLabel(targetMember.phoneNumber)
    }

    private func updateServiceList() {
        targetMember.services = faCoreManager.getServiceList(for: targetMember)
        serviceCollectionView.reloadData()

        emptyGuideLabel.isHidden = !targetMember.services.isEmpty
    }

    // MARK: - Delegate Methods (UICollectionView etc.)

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return targetMember.services.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let service = targetMember.services[indexPath.item]
        let cell = serviceCollectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCollectionViewCell", for: indexPath) as! ServiceCollectionViewCell
        cell.setup(service: service, cellSize: serviceCollectionView.bounds.size)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = serviceCollectionView.bounds.width
        let height: CGFloat = MemberCollectionViewCell.cellHeight
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        targetServiceIndex = indexPath.item
        performSegue(withIdentifier: "toDetails", sender: nil)
    }

    // MARK: - Utilities

    private func setEmailLabel(_ text: String) {
        var email: String = ""
        if text.isEmpty {
            email = "N/A"
        } else {
            email = text
        }
        emailLabel.text = email
    }

    private func setPhoneNumberLabel(_ text: String) {
        var phoneNumber: String = ""
        if text.isEmpty {
            phoneNumber = "N/A"
        } else {
            phoneNumber = text
        }
        phoneNumberLabel.text = phoneNumber
    }

}
