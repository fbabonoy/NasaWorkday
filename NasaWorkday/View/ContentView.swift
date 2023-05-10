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
                        NasaDataView(result: result)
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

struct NasaDataView: View {
    let result: NasaData

    var body: some View {
        VStack(alignment: .leading) {
            Text(result.title ?? "")
                .font(.headline)
                .lineLimit(1)
            if let description = result.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
        }
        .padding(.leading, 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: NasaViewModel())
    }
}
