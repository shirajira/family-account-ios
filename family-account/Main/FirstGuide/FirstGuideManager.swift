//--------------------------------------------------------------------------//
// Family Account - FirstGuideManager.swift
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

class FirstGuideManager {
    /// User defaults
    private let userDefaults = UserDefaults.standard

    /// Key
    private let key: String = "FirstGuideNeverShowAgain"

    // MARK: -

    func shouldShow() -> Bool {
        let neverShowAgain = get(forKey: key)
        return !neverShowAgain
    }

    func neverShowAgain(_ yes: Bool) {
        set(forKey: key, with: yes)
    }

    func removeAll() {
        userDefaults.removeObject(forKey: key)
    }

    // MARK: - Utilities

    private func get(forKey: String) -> Bool {
        var ret: Bool = false
        if let value = userDefaults.object(forKey: forKey) as? Bool {
            ret = value
        } else {
            userDefaults.register(defaults: [forKey: false])
            userDefaults.set(false, forKey: key)
            ret = false
        }
        return ret
    }

    private func set(forKey: String, with value: Bool) {
        if userDefaults.object(forKey: forKey) == nil {
            userDefaults.register(defaults: [forKey: value])
        }
        userDefaults.setValue(value, forKey: forKey)
    }

}
