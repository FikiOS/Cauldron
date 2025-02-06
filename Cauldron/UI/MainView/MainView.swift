//
//  MainView.swift
//  Cauldron
//
//  Created by David Alarcon on 3/2/25.
//

import SwiftUI

struct MainView: View {
  @State private var selectedMenu: String? = .none

  var body: some View {
    NavigationSplitView {
      List(selection: $selectedMenu) {
        Section("Formulae") {
          SidebarItem(icon: "checkmark.circle", title: "Installed", badge: "61")
          SidebarItem(icon: "arrow.triangle.2.circlepath", title: "Outdated", badge: "6")
          SidebarItem(icon: "square.stack", title: "All Formulae", badge: "5499")
          SidebarItem(icon: "leaf", title: "Leaves", badge: "4")
          SidebarItem(icon: "building.columns", title: "Repositories", badge: "1")
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
          ContentView()
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
      /*
      switch selectedMenu {
      case "Installed":
        ContentView()
      default:
        Text("Select a menu item")
          .font(.largeTitle)
          .foregroundColor(.gray)
      } */
    }
  }
}

struct SidebarItem: View {
  var icon: String
  var title: String
  var badge: String? = nil

  var body: some View {
    HStack {
      Label(title, systemImage: icon)
      Spacer()
      if let badge = badge {
        Text(badge)
          .font(.caption)
          .foregroundColor(.white)
          .padding(5)
          .background(Color.blue)
          .clipShape(Capsule())
      }
    }
    .tag(title)
  }
}

#Preview {
  MainView()
}
