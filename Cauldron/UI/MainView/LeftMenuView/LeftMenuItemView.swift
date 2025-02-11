//
//  LeftMenuItemView.swift
//  Cauldron
//
//  Created by David Alarcon on 11/2/25.
//

import SwiftUI

struct LeftMenuItemView: View {
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
  LeftMenuItemView(icon: "plus.circle", title: "Preview")
}
