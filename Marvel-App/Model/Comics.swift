//
//  Comics.swift
//  Marvel-App
//
//  Created by YILDIRIM on 12.02.2023.
//

import Foundation

// MARK: - Comics
struct ComicsResponse: Codable,Hashable {
    let data: ComicsData
}

// MARK: - DataClass
struct ComicsData: Codable,Hashable {
    let total, count: Int
    let results: [ComicsResult]
}

// MARK: - Result
struct ComicsResult: Codable,Hashable {
    let id: Int
    let title: String
    let description: String?
    let pageCount: Int
    let thumbnail: Thumbnail
}

