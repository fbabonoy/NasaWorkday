//
//  SubView.swift
//  NasaWorkday
//
//  Created by fernando babonoyaba on 5/9/23.
//

import Foundation
import SwiftUI
import Kingfisher

struct SubView: View {
    var nasaPost: NasaData

    var body: some View {
        VStack {
            KFImage(URL(string: nasaPost.image))
                            .placeholder {
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                            }
                            .resizable()
                            .scaledToFit()
            Text(nasaPost.title ?? "")
                .padding()
            Text(nasaPost.description ?? "")
            Spacer()
        }
        .navigationTitle(nasaPost.date ?? "No date")

    }
}
