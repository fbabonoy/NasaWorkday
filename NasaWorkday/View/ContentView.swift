//
//  ContentView.swift
//  NasaWorkday
//
//  Created by fernando babonoyaba on 5/9/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: NasaViewModel

    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.state {
                case .loading:
                    ProgressView().task {
                        self.viewModel.loadAllBreeds()
                    }
                case .loaded(let results):
                    List(results, id: \.id) { result in
                        Text(result.title ?? "")
                    }
                case .error(let error):
                    Text(error.localizedDescription)
                        .padding()
                case .empty(let message):
                    Text(message)
                }
            }
            .navigationTitle("Nasa Posts")
            .listStyle(.insetGrouped)
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: NasaViewModel())
    }
}