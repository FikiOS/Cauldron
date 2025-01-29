//
//  ListInstalledFormulasCommand.swift
//  Cauldron
//
//  Created by David Alarcon on 12/12/2023.
//  Copyright © 2023 David Alarcon. All rights reserved.
//

import Foundation

struct ListInstalledFormulasCommand: BrewCommand { 
    var command: Command { .info }
    var arguments: [String] { ["--installed"] }
}
