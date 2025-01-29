//
//  ContentView.swift
//  Cauldron
//
//  Created by David Alarcon on 25/1/25.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = InstalledFormulasViewModel()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            Task {
                await viewModel.fetchInstalledFormulas()
            }
        }
    }
}

#Preview {
    ContentView()
}
