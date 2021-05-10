//--------------------------------------------------------------------------//
// Family Account - FAFileManager.swift
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

class FAFileManager {

    static private let fileManager = FileManager.default

    static let documentDirectory: URL = {
        let dir: URL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir
    }()

    static func checkUrlExists(url: URL) -> Bool {
        let exists = fileManager.fileExists(atPath: url.path)
        return exists
    }

    static func listSegments(from url: URL) -> [String] {
        guard let files = try? fileManager.contentsOfDirectory(atPath: url.path) else {
            return []
        }
        return files
    }

    @discardableResult
    static func makeDirectory(url: URL) -> Bool {
        if checkUrlExists(url: url) {
            return true
        }
        var ret: Bool = false
        do {
            try fileManager.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
            ret = true
        } catch {
            ret = false
        }
        return ret
    }

    @discardableResult
    static func remove(url: URL) -> Bool {
        var ret: Bool = false
        do {
            try fileManager.removeItem(at: url)
            ret = true
        } catch {
            ret = false
        }
        return ret
    }

    @discardableResult
    static func rename(_ src: URL, to dst: URL) -> Bool {
        var ret: Bool = false
        do {
            try fileManager.moveItem(at: src, to: dst)
            ret = true
        } catch {
            ret = false
        }
        return ret
    }

    @discardableResult
    static func copy(_ src: URL, to dst: URL) -> Bool {
        var ret: Bool = false
        do {
            try fileManager.copyItem(at: src, to: dst)
            ret = true
        } catch {
            ret = false
        }
        return ret
    }

}
