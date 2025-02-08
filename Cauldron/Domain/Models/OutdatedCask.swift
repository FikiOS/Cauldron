//
//  OutdatedCask.swift
//  Cauldron
//
//  Created by David Alarcon on 7/2/25.
//

import Foundation

struct OutdatedCask: Identifiable {
  var id: String { name }

  var name: String
  var installedVersions: [String]
  var currentVersion: String

  var installedVersionsString: String {
    installedVersions.joined(separator: ", ")
  }
}
