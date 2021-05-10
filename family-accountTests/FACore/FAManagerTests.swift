//--------------------------------------------------------------------------//
// Family Account - FAManagerTests.swift
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

import XCTest
@testable import family_account

class FAManagerTests: XCTestCase {

    private let testRoot: String = "TestMembers"

    func testRootDirectory() {
        let faCoreManager = FACoreManager(testRoot: testRoot)

        XCTAssertTrue(faCoreManager.createRootDirectory())
        XCTAssertTrue(faCoreManager.createRootDirectory())
        XCTAssertTrue(faCoreManager.removeRootDirectory())
        XCTAssertFalse(faCoreManager.removeRootDirectory())
    }

    func testMembers() {
        let faCoreManager = FACoreManager(testRoot: testRoot)
        faCoreManager.createRootDirectory()

        let memberC = FAMember(filename: "memberC.json", name: "C", relationship: "CC", email: "CCC", phoneNumber: "CCCC", iconFilePath: "CCCCC", services: [])
        XCTAssertEqual(faCoreManager.add(member: memberC), FAErrorCode.success)
        XCTAssertEqual(faCoreManager.add(member: memberC), FAErrorCode.alreadyExists)
        let memberB = FAMember(filename: "memberB.json", name: "B", relationship: "BB", email: "BBB", phoneNumber: "BBBB", iconFilePath: "BBBBB", services: [])
        XCTAssertEqual(faCoreManager.add(member: memberB), FAErrorCode.success)
        let memberA = FAMember(filename: "memberA.json", name: "A", relationship: "AA", email: "AAA", phoneNumber: "AAAA", iconFilePath: "AAAAA", services: [])
        XCTAssertEqual(faCoreManager.add(member: memberA), FAErrorCode.success)

        let members = faCoreManager.getMemberList()
        XCTAssertEqual(members.count, 3)
        XCTAssertEqual(members[0].filename, "memberA.json")
        XCTAssertEqual(members[1].filename, "memberB.json")
        XCTAssertEqual(members[2].filename, "memberC.json")
        for member in members {
            print(member)
        }

        let memberD = FAMember(filename: "memberD.json", name: "D", relationship: "DD", email: "DDD", phoneNumber: "DDDD", iconFilePath: "DDDDD", services: [])
        XCTAssertEqual(faCoreManager.update(member: memberD), FAErrorCode.noFile)
        XCTAssertEqual(faCoreManager.remove(member: memberD), FAErrorCode.noFile)
        XCTAssertEqual(faCoreManager.add(member: memberD), FAErrorCode.success)

        let memberAA = FAMember(filename: "memberA.json", name: "AA", relationship: "AA", email: "AAA", phoneNumber: "AAAA", iconFilePath: "AAAAA", services: [])
        XCTAssertEqual(faCoreManager.update(member: memberAA), FAErrorCode.success)

        XCTAssertEqual(faCoreManager.remove(member: memberB), FAErrorCode.success)
        let modifiedMembers = faCoreManager.getMemberList()
        XCTAssertEqual(modifiedMembers.count, 3)
        XCTAssertEqual(modifiedMembers[0].filename, "memberA.json")
        XCTAssertEqual(modifiedMembers[1].filename, "memberC.json")
        XCTAssertEqual(modifiedMembers[2].filename, "memberD.json")
        for member in modifiedMembers {
            print(member)
        }

        faCoreManager.removeRootDirectory()
    }

}
