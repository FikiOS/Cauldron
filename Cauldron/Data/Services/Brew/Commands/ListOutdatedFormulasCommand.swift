//
//  ListOutdatedFormulasCommand.swift
//  Cauldron
//
//  Created by David Alarcon on 7/2/25.
//

import Foundation

struct ListOutdatedFormulasCommand: BrewCommand {
  var subCommand: SubCommand { .outdated }
  var arguments: [String] { Array.empty }
}
