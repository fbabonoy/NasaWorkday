//
//  File.swift
//  NasaWorkday
//
//  Created by fernando babonoyaba on 5/9/23.
//

import Foundation

struct NasaData: Hashable {
    let id = UUID()
    let title: String?
    let description: String?
    let href: String

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case href
    }
}

struct NasaResponse: Codable {
    let collection: Collection
}

struct Collection: Codable {
    let items: [Item]
}

struct Item: Codable {
    let data: [PostData]
    let links: [Link]
}

struct PostData: Codable {
    let title: String?
    let description: String?
    let mediaType: MediaType?

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case mediaType = "media_type"
    }
}

struct Link: Codable {
    let href: String?
}

enum MediaType: String, Codable {
    case image

}
