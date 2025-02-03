//
//  ListInstalledResponse.swift
//  Cauldron
//
//  Created by David Alarcon on 2/2/25.
//

import Foundation

struct ListInstalledResponse: Decodable {
  let formulae: [FormulaeResponse]
  // let casks
}

struct FormulaeResponse: Decodable {
  let name: String
  let fullName: String
  let linkedKeg: String?

  enum CodingKeys: String, CodingKey {
    case name
    case fullName = "full_name"
    case linkedKeg = "linked_keg"
  }
}

//struct Formulae: Decodable, Identifiable {
//  // MARK: - Core Properties
//  let name: String
//  let fullName: String
//  let desc: String
//  let license: String
//  let homepage: String
//  let tap: String
//
//  // Use name as identifier
//  var id: String { name }
//
//  // MARK: - Version Info
//  let versions: Versions
//  let revision: Int
//  let installedVersions: [InstalledVersion]
//  let linkedKeg: String?
//  let outdated: Bool
//
//  // MARK: - Dependencies
//  let buildDependencies: [String]
//  let dependencies: [String]
//  let runtimeDependencies: [RuntimeDependency]?
//
//  // MARK: - Status Flags
//  let deprecated: Bool
//  let disabled: Bool
//  let pinned: Bool
//
//  // MARK: - Coding Keys
//  private enum CodingKeys: String, CodingKey {
//    case name, tap, desc, license, homepage, versions, revision
//    case fullName = "full_name"
//    case installedVersions = "installed"
//    case linkedKeg = "linked_keg"
//    case outdated
//    case buildDependencies = "build_dependencies"
//    case dependencies
//    case deprecated, disabled, pinned
//  }
//}
//
//// MARK: - Supporting Models
//struct Versions: Decodable {
//  let stable: String
//  let head: String?
//  let bottle: Bool
//}
//
//struct InstalledVersion: Decodable {
//  let version: String
//  let installedAsDependency: Bool
//  let installedOnRequest: Bool
//  let time: TimeInterval
//  let runtimeDependencies: [RuntimeDependency]?
//
//  private enum CodingKeys: String, CodingKey {
//    case version, time
//    case installedAsDependency = "installed_as_dependency"
//    case installedOnRequest = "installed_on_request"
//    case runtimeDependencies = "runtime_dependencies"
//  }
//}
//
//struct RuntimeDependency: Decodable {
//  let fullName: String
//  let version: String
//  let declaredDirectly: Bool
//
//  private enum CodingKeys: String, CodingKey {
//    case fullName = "full_name"
//    case version
//    case declaredDirectly = "declared_directly"
//  }
//}
//
//// MARK: - Computed Properties Extension
//extension Formulae {
//  var currentVersion: String? {
//    installedVersions.first?.version
//  }
//
//  var installDate: Date {
//    guard let time = installedVersions.first?.time else { return Date() }
//    return Date(timeIntervalSince1970: time)
//  }
//
//  var isOutdatedVersion: Bool {
//    guard let current = currentVersion else { return false }
//    return current != versions.stable
//  }
//}
