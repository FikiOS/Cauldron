//
//  MainView.swift
//  Cauldron
//
//  Created by David Alarcon on 3/2/25.
//

import SwiftUI

struct MainView: View {
  @State private var selectedMenu: String? = "Formulas"
  @State private var numberOfInstalledFormulas = Int.zero
  @State private var numberOfInstalledCasks = Int.zero

  var body: some View {
    NavigationSplitView {
      LeftMenuView(selectedMenu: $selectedMenu,
                   numberOfInstalledFormulas: $numberOfInstalledFormulas,
                   numberOfInstalledCasks: $numberOfInstalledCasks)
    } detail: {
      // Switch based on the selected menu
      if let selected = selectedMenu {
        switch selected {
        case "Formulas":
          ContentView(numberOfInstalledFormulaes: $numberOfInstalledFormulas)
            .navigationTitle("Cauldron")
        default:
          Text("Unknown menu item")
            .font(.largeTitle)
            .foregroundColor(.red)
        }
      } else {
        Text("Select a menu item")
          .font(.largeTitle)
          .foregroundColor(.gray)
      }
    }
    .accentColor(.orange)
  }
}

#Preview {
  MainView()
}
