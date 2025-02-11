//
//  OutdatedFormulaesAndTasksResponse.swift
//  Cauldron
//
//  Created by David Alarcon on 7/2/25.
//

import Foundation

struct OutdatedFormulaesAndTasksResponse: Decodable {
  let formulae: [OutdatedFormulaeResponse]
  let casks: [OutdatedCaskResponse]
}

struct OutdatedFormulaeResponse: Decodable {
  let name: String
  let installedVersions: [String]
  let currentVersion: String
  let pinned: Bool
  let pinnedVersion: String?

  // Coding keys to map JSON keys to Swift property names
  enum CodingKeys: String, CodingKey {
    case name
    case installedVersions = "installed_versions"
    case currentVersion = "current_version"
    case pinned
    case pinnedVersion = "pinned_version"
  }
}

struct OutdatedCaskResponse: Decodable {
  let name: String
  let installedVersions: [String]
  let currentVersion: String

  // Coding keys to map JSON keys to Swift property names
  enum CodingKeys: String, CodingKey {
    case name
    case installedVersions = "installed_versions"
    case currentVersion = "current_version"
  }
}
