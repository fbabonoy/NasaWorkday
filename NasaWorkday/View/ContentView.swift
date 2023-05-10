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
                        self.viewModel.loadAllPosts()
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
            .searchable(text: $viewModel.searchText)
            .listStyle(.insetGrouped)
        }
    }
}

struct NasaDataView: View {
    let result: NasaData

    var body: some View {
        HStack {
            KFImage(URL(string: result.image))
                            .placeholder {
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: getImageWidth())
                            .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading) {
                if let title = result.title {
                    Text(title)
                        .font(.headline)
                        .lineLimit(1)
                }
                Spacer()
                if let description = result.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
                Spacer()
                if let date = result.date {
                    Text(date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 5)
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
