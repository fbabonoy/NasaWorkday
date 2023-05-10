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
    let image: String
    let date: String?

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case href = "image"
        case date = "date_created"
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
    let dateCreated: String?

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case mediaType = "media_type"
        case dateCreated = "date_created"
    }
}

struct Link: Codable {
    let href: String?
}

enum MediaType: String, Codable {
    case image
}
