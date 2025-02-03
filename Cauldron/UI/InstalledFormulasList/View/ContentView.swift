//
//  ContentView.swift
//  Cauldron
//
//  Created by David Alarcon on 25/1/25.
//

import SwiftUI

struct ContentView: View {
  @State private var viewModel = InstalledFormulasViewModel()
  @State var selection: String?

  var body: some View {
    Table(viewModel.formulaes) {
      TableColumn("Name", value: \.name)
      TableColumn("Full Name", value: \.fullName)
      TableColumn("Version", value: \.linkedKeg)
    }
    .padding()
    .onAppear {
      Task {
        await viewModel.fetchInstalledFormulaes()
      }
    }
  }
}

#Preview {
    ContentView()
}
