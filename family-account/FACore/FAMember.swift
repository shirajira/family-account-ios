//--------------------------------------------------------------------------//
// Family Account - FAMember.swift
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

import Foundation

struct FAMember: Codable {
    /// File name
    var filename: String = ""

    /// Name
    var name: String = ""

    /// Relationship
    var relationship: String = ""

    /// Email
    var email: String = ""

    /// Phone number
    var phoneNumber: String = ""

    /// Icon file name (Reserved)
    var iconFilename: String = ""

    /// Services
    var services: [FAService] = []

    /**
     Convert the instance to json format.
     - returns: Json data
     */
    func json() -> Data {
        return try! JSONEncoder().encode(self)
    }

    /**
     Import json data.
     - parameter jsonData: Json data
     - returns: true: Success / false: Failure
     */
    mutating func importJson(jsonData: Data) -> Bool {
        guard let model = try? JSONDecoder().decode(FAMember.self, from: jsonData) else {
            return false
        }
        self = model
        return true
    }

}
