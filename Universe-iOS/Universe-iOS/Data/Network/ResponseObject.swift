//
//  ResponseObject.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/02.
//

import Foundation

struct ResponseObject<T> {
    let httpStatusCode: Int?
    let type: String?
    let customCode: Int?
    let success: Bool?
    let message: String?
    let data: T?
    
    enum CodingKeys: String, CodingKey {
        case httpStatusCode
        case success
        case message
        case data
        case type
        case customCode
    }
}

extension ResponseObject: Decodable where T: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        httpStatusCode = try? container.decode(Int.self, forKey: .httpStatusCode)
        type = try? container.decode(String.self, forKey: .type)
        customCode = try? container.decode(Int.self, forKey: .customCode)
        success = try? container.decode(Bool.self, forKey: .success)
        message = try? container.decode(String.self, forKey: .message)
        do {
            data = try container.decode(T.self, forKey: .data)
        } catch let error {
            print("🥲 ResponseObject - error: \(error)")
            throw APIError.decodingErr
        }
    }
}
