//--------------------------------------------------------------------------//
// Family Account - FACoreManager.swift
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

class FACoreManager {

    // MARK: - Properties

    static var rootName: String = "Members" // Production root name
    let rootUrl: URL

    // MARK: - Initializers

    /**
     Initializer for production.
     */
    init() {
        rootUrl = FAFileManager.documentDirectory.appendingPathComponent(FACoreManager.rootName)
    }

    /**
     Initializer for development.
     */
    init(testRoot: String) {
        rootUrl = FAFileManager.documentDirectory.appendingPathComponent(testRoot)
    }

    // MARK: - Setup or Teardown Methods

    /**
     Create the root directory.
     - returns: true: Success / false: Failure
     */
    @discardableResult
    func createRootDirectory() -> Bool {
        if FAFileManager.checkUrlExists(url: rootUrl) {
            return true
        }
        return FAFileManager.makeDirectory(url: rootUrl)
    }

    /**
     Remove the root directory.
     - returns: true: Success / false: Failure
     */
    @discardableResult
    func removeRootDirectory() -> Bool {
        if !FAFileManager.checkUrlExists(url: rootUrl) {
            return false
        }
        return FAFileManager.removeUrl(url: rootUrl)
    }

    // MARK: - Update Methods

    /**
     Add a new member.
     - parameter member: New member profile
     - returns: Error code
     */
    func addMember(member: FAMember) -> FAErrorCode {
        let fileUrl = rootUrl.appendingPathComponent(member.filename)
        if FAFileManager.checkUrlExists(url: fileUrl) {
            return .alreadyExists
        }
        var ret: FAErrorCode = .unknown
        do {
            try member.json().write(to: fileUrl, options: .completeFileProtection)
            ret = .success
        } catch {
            ret = .unknown
        }
        return ret
    }

    /**
     Update the member.
     - parameter member: Member profile to update
     - returns: Error code
     */
    func updateMember(member: FAMember) -> FAErrorCode {
        let fileUrl = rootUrl.appendingPathComponent(member.filename)
        if !FAFileManager.checkUrlExists(url: fileUrl) {
            return .noFile
        }
        var ret: FAErrorCode = .unknown
        do {
            try member.json().write(to: fileUrl, options: .completeFileProtection)
            ret = .success
        } catch {
            ret = .unknown
        }
        return ret
    }

    /**
     Remove the member.
     - parameter member: Member profile to remove
     - returns: Error code
     */
    func removeMember(member: FAMember) -> FAErrorCode {
        let fileUrl = rootUrl.appendingPathComponent(member.filename)
        if !FAFileManager.checkUrlExists(url: fileUrl) {
            return .noFile
        }
        let ret = FAFileManager.removeUrl(url: fileUrl)
        return ret ? .success : .unknown
    }

    /**
     Get the member list.
     - returns: Member list
     */
    func getMemberList() -> [FAMember] {
        let files = FAFileManager.listSegments(url: rootUrl)
        var members: [FAMember] = []
        for file in files {
            let fileUrl = rootUrl.appendingPathComponent(file)
            if !FAFileManager.checkUrlExists(url: fileUrl) {
                continue
            }
            guard let fin = FileHandle(forReadingAtPath: fileUrl.path) else {
                continue
            }
            defer {
                fin.closeFile()
            }
            let jsonData = fin.readDataToEndOfFile()
            var member = FAMember()
            if member.importJson(jsonData: jsonData) {
                members.append(member)
            }
        }
        members.sort { (lhMember, rhMember) -> Bool in
            return lhMember.name < rhMember.name
        }
        return members
    }

}
