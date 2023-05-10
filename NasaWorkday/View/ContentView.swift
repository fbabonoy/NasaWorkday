//
//  ContentView.swift
//  NasaWorkday
//
//  Created by fernando babonoyaba on 5/9/23.
//

import SwiftUI
import Kingfisher

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
                        NavigationLink(destination: SubView(nasaPost: result)) {
                            NasaDataView(result: result)
                        }
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
        HStack {
            KFImage(URL(string: result.href))
                            .placeholder {
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: getImageWidth(), height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
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

    private func getImageWidth() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return screenWidth / 5
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: NasaViewModel())
    }
}
