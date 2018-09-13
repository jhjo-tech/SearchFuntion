//
//  Search.swift
//  SearchTest
//
//  Created by Jo JANGHUI on 2018. 9. 11..
//  Copyright © 2018년 JhDAT. All rights reserved.
//

struct Search: Decodable {
    var word: String?
    var relatedQuery: [String]?
    
    init(from decoder: Decoder) throws {
        // 같은 타입을 가진 경우 singleValueContainer()
        let container = try decoder.singleValueContainer()
        if let result = try? container.decode(String.self) {
            self.word = result
        }
        if let retult = try? container.decode([String].self) {
            self.relatedQuery = retult
        }
    }
}
