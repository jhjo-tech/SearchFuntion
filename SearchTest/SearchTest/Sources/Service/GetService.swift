//
//  Get.swift
//  SearchTest
//
//  Created by Jo JANGHUI on 2018. 9. 11..
//  Copyright © 2018년 JhDAT. All rights reserved.
//

import Alamofire

struct API {
    static let searchURL = "https://en.wikipedia.org/w/api.php?action=opensearch&search="
}

struct GetService {
    func search (words: String, completion: @escaping ([Search]) -> ()) {
        
        guard let url = (API.searchURL + words).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let alramofire = Alamofire.request(url).validate(statusCode: 200..<400)
        alramofire.responseData { (response) in
            switch response.result {
            case .success(let value):
                do {
                    let result = try JSONDecoder().decode([Search].self, from: value)
                    completion(result)
                } catch {
                    print("parsing error")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
