//
//  WikiData.swift
//  WhatFlower
//
//  Created by Anna Shark on 15/9/21.
//

import Foundation

struct WikiData: Codable{
    let query: Query
}

struct Query: Codable{
    let pageids: [String]
    let pages: [String : Pages]
}

struct Pages: Codable{
    let extract: String
    let thumbnail: Thumbnail
    
}

struct Thumbnail: Codable{
    let source: String
    
}


