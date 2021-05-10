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

class MembersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    /// FA manager
    private let faCoreManager = FACoreManager()

    /// Members
    private var members: [FAMember] = []

    /// Target member
    private var targetMember = FAMember()

    @IBOutlet private weak var memberCollectionView: UICollectionView!
    @IBOutlet private weak var copyrightLabel: UILabel!

    // MARK: - Override Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupFAManager()
        setupCollectionView()
        setupLongPressRecognizer()
        setupCopyrightNotation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateMemberList()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddMember" {
            if let addMemberViewController = segue.destination as? AddMemberViewController {
                addMemberViewController.setup(editMode: false, targetMember: nil)
            }
        } else if segue.identifier == "toProfile" {
            if let profileViewController = segue.destination as? ProfileViewController {
                profileViewController.setup(member: targetMember)
            }
        }
    }

    // MARK: - Setup Methods

    private func setupNavigationBar() {
        if let navigation = navigationController {
            navigation.navigationBar.barTintColor = .mainNavigation
            navigation.navigationBar.isTranslucent = false
            navigation.navigationBar.tintColor = .mainWhite
            navigation.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.mainWhite]
            navigation.navigationBar.shadowImage = UIImage()
        }
    }

    private func setupFAManager() {
        faCoreManager.createRootDirectory()
    }

    private func setupCollectionView() {
        memberCollectionView.register(
            UINib(nibName: "MemberCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "MemberCollectionViewCell"
        )
        memberCollectionView.delegate = self
        memberCollectionView.dataSource = self
    }

    private func setupLongPressRecognizer() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(editMember(_:)))
        longPressRecognizer.allowableMovement = 10
        longPressRecognizer.minimumPressDuration = 0.5
        memberCollectionView.addGestureRecognizer(longPressRecognizer)
    }

    private func setupCopyrightNotation() {
        let copyright = createCopyrightNotation()
        copyrightLabel.text = copyright
    }

    // MARK: - Update Methods

    private func updateMemberList() {
        members = faCoreManager.getMemberList()
        memberCollectionView.reloadData()
    }

    // MARK: - Actions

    @objc
    private func editMember(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let point = sender.location(in: memberCollectionView)
            guard let indexPath = memberCollectionView.indexPathForItem(at: point) else {
                return
            }
            let targetMember = members[indexPath.item]
            guard let addMemberViewController = storyboard?.instantiateViewController(withIdentifier: "AddMember") as? AddMemberViewController else {
                return
            }
            addMemberViewController.setup(editMode: true, targetMember: targetMember)
            navigationController?.pushViewController(addMemberViewController, animated: true)
        }
    }

    // MARK: - Delegate Methods (UICollectionView etc.)

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return members.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let member = members[indexPath.item]
        let cell = memberCollectionView.dequeueReusableCell(withReuseIdentifier: "MemberCollectionViewCell", for: indexPath) as! MemberCollectionViewCell
        cell.setup(member: member, cellSize: memberCollectionView.bounds.size)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = memberCollectionView.bounds.width
        let height: CGFloat = MemberCollectionViewCell.cellHeight
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        targetMember = members[indexPath.item]
        performSegue(withIdentifier: "toProfile", sender: nil)
    }

}
