//
//  FormulasResponse.swift
//  Cauldron
//
//  Created by David Alarcon on 8/2/25.
//

import Foundation

struct FormulasResponse: Decodable {
  var formulas: [FormulasResponse.Formula]

  struct Formula: Decodable {
    var name: String
    var description: String
    var versions: [FormulasResponse.Formula.Version]

    struct Version: Decodable {
      var stable: String
    }

    enum CodingKeys: String, CodingKey {
      case name
      case description = "desc"
      case versions
    }
  }
}
