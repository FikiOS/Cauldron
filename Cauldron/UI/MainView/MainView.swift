//
//  MainView.swift
//  Cauldron
//
//  Created by David Alarcon on 3/2/25.
//

import SwiftUI

struct MainView: View {
  @State private var selectedMenu: String? = .none
  @State private var numberOfInstalledFormulaes = Int.zero
  @State private var numberOfOutdatedFormulaes = Int.zero
  @State private var numberOfOutdatedCasks = Int.zero

  var body: some View {
    NavigationSplitView {
      List(selection: $selectedMenu) {
        Section("Formulae") {
          SidebarItem(icon: "checkmark.circle", title: "Installed", badge: numberOfInstalledFormulaes)
          SidebarItem(icon: "arrow.triangle.2.circlepath", title: "Outdated", badge: numberOfOutdatedFormulaes, casks: numberOfOutdatedCasks)
          SidebarItem(icon: "square.stack", title: "All Formulae", badge: 5499)
          SidebarItem(icon: "leaf", title: "Leaves", badge: 4)
          SidebarItem(icon: "building.columns", title: "Repositories", badge: 1)
        }
        Section("Tools") {
          SidebarItem(icon: "stethoscope", title: "Doctor")
          SidebarItem(icon: "clock.arrow.circlepath", title: "Update")
        }
      }
      .listStyle(SidebarListStyle())

    } detail: {
      // Switch based on the selected menu
      if let selected = selectedMenu {
        switch selected {
        case "Installed":
          ContentView(numberOfInstalledFormulaes: $numberOfInstalledFormulaes)
        case "Outdated":
          OutdatedFormulaesView(numberOfOutdatedFormulaes: $numberOfOutdatedFormulaes,
                                numberOfOutdatedCasks: $numberOfOutdatedCasks)
        case "All Formulae":
          FormulasListView()
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

struct SidebarItem: View {
  var icon: String
  var title: String
  var badge: Int = .zero
  var casks: Int = .zero

  var body: some View {
    HStack {
      Label(title, systemImage: icon)
        .badge(badge)
        .badge(casks)
    }
    .tag(title)
  }
}

#Preview {
  MainView()
}
