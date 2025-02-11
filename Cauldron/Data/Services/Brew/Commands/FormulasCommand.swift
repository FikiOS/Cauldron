//
//  FormulasCommand.swift
//  Cauldron
//
//  Created by David Alarcon on 8/2/25.
//

import Foundation

struct FormulasCommand: BrewCommand {
  var subCommand: SubCommand { .info }
  var arguments: [String] = Array.empty
  var evalAll: Bool { return true }
}
