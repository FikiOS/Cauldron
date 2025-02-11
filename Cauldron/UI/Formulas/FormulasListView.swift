//
//  FormulasListView.swift
//  Cauldron
//
//  Created by David Alarcon on 8/2/25.
//

import SwiftUI

struct FormulasListView: View {
  @State private var viewModel = FormulasListViewModel()
  @State var selection: String?

  var body: some View {
    Table(viewModel.formulas) {
      TableColumn("Name", value: \.name)
      TableColumn("Description", value: \.description)
      TableColumn("Version", value: \.version)
    }
    .padding()
    .onAppear {
      Task {
        try await viewModel.fetchFormulas()
      }
    }
  }
}

#Preview {
  FormulasListView()
}
