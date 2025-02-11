//
//  LeftMenuView.swift
//  Cauldron
//
//  Created by David Alarcon on 11/2/25.
//

import SwiftUI

struct LeftMenuView: View {
  @Binding var selectedMenu: String?
  @Binding var numberOfInstalledFormulas: Int
  @Binding var numberOfInstalledCasks: Int

  var body: some View {
    List(selection: $selectedMenu) {
      Section("Formulas") {
        SidebarItem(icon: "newspaper", title: "Formulas", badge: numberOfInstalledFormulas)
        SidebarItem(icon: "arrow.triangle.2.circlepath", title: "Casks", badge: numberOfInstalledCasks)
      }
      Section("Tools") {
        SidebarItem(icon: "stethoscope", title: "Analytics")
        SidebarItem(icon: "clock.arrow.circlepath", title: "Log")
      }
    }
    .listStyle(SidebarListStyle())
  }
}

struct SidebarItem: View {
  var icon: String
  var title: String
  var badge: Int = .zero

  var body: some View {
    HStack {
      Label(title, systemImage: icon)
        .badge(badge)
    }
    .tag(title)
  }
}

#Preview {
  LeftMenuView(selectedMenu: Binding.constant("Formulas"), numberOfInstalledFormulas: Binding.constant(10), numberOfInstalledCasks: Binding.constant(5))
}
