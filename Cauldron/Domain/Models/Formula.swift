//
//  Formula.swift
//  Cauldron
//
//  Created by David Alarcon on 8/2/25.
//

import Foundation

struct Formula: Identifiable {
  var id: String { name }

  var name: String
  var description: String
  var version: String
}
