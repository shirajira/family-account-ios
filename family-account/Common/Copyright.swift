//--------------------------------------------------------------------------//
// Family Account - Copyright.swift
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

/**
 Create a copyright notation based on the current year.
 - returns: Copyright (© yyyy Family Account)
 */
func createCopyrightNotation() -> String {
    let currentYear = timestamp(format: "yyyy")
    let notation = "© \(currentYear) Family Account"
    return notation
}
