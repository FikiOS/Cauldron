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
        LeftMenuItemView(icon: "newspaper", title: "Formulas", badge: numberOfInstalledFormulas)
        LeftMenuItemView(icon: "arrow.triangle.2.circlepath", title: "Casks", badge: numberOfInstalledCasks)
      }
      Section("Tools") {
        LeftMenuItemView(icon: "stethoscope", title: "Analytics")
        LeftMenuItemView(icon: "clock.arrow.circlepath", title: "Log")
      }
    }
    .listStyle(SidebarListStyle())
  }
}

#Preview {
  LeftMenuView(selectedMenu: Binding.constant("Formulas"), numberOfInstalledFormulas: Binding.constant(10), numberOfInstalledCasks: Binding.constant(5))
}
