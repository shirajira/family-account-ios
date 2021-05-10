//--------------------------------------------------------------------------//
// Family Account - MemberCollectionViewCell.swift
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

class MemberCollectionViewCell: UICollectionViewCell {

    static let cellHeight: CGFloat = 48.0

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var memberNameLabel: UILabel!

    // MARK: - Override Methods

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        memberNameLabel.text = ""
    }

    // MARK: - Setup Methods

    func setup(member: FAMember, cellSize: CGSize) {
        // 1) Name
        memberNameLabel.text = member.name

        // 2) Cell width
        containerView.widthAnchor.constraint(equalToConstant: cellSize.width).isActive = true
    }

}
