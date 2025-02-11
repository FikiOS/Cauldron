//
//  OutdatedFormulaesView.swift
//  Cauldron
//
//  Created by David Alarcon on 7/2/25.
//

import SwiftUI

struct OutdatedFormulaesView: View {
  @State private var viewModel = OutdatedFormulaesViewModel()
  @State var selection: String?
  @Binding var numberOfOutdatedFormulaes: Int
  @Binding var numberOfOutdatedCasks: Int

  var body: some View {
    VStack {
      Text("Formulaes")
        .font(.subheadline)
        .padding(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cornerRadius(8)
        .padding(.bottom, 4)
        .foregroundStyle(.secondary)
      Table(viewModel.formulaes) {
        TableColumn("Name", value: \.name)
        TableColumn("Installed Versions", value: \.installedVersionsString)
        TableColumn("Current Version", value: \.currentVersion)
      }
      Text("Casks")
        .font(.subheadline)
        .padding(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cornerRadius(8)
        .padding(.bottom, 4)
        .foregroundStyle(.secondary)
      Table(viewModel.casks) {
        TableColumn("Name", value: \.name)
        TableColumn("Installed Versions", value: \.installedVersionsString)
        TableColumn("Current Version", value: \.currentVersion)
      }
      Spacer()
    }
    .padding()
    .onAppear {
      Task {
        await viewModel.fetchOutdatedFormulaes()
        numberOfOutdatedFormulaes = viewModel.formulaes.count
        numberOfOutdatedCasks = viewModel.casks.count
      }
    }
  }
}

#Preview {
  OutdatedFormulaesView(numberOfOutdatedFormulaes: Binding.constant(10), numberOfOutdatedCasks: Binding.constant(6))
}
