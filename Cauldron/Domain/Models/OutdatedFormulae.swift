//
//  OutdatedFormulae.swift
//  Cauldron
//
//  Created by David Alarcon on 7/2/25.
//

import Foundation

struct OutdatedFormulae: Identifiable {
  var id: String { name }

  var name: String
  var installedVersions: [String]
  var currentVersion: String
  var pinned: Bool
  var pinnedVersion: String?

  var installedVersionsString: String {
    installedVersions.joined(separator: ", ")
  }
}
