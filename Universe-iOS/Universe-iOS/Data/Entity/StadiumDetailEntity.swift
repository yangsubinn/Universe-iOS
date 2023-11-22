//
//  StadiumDetailEntity.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/02/01.
//

import Foundation

// MARK: - StadiumDetailEntity
struct StadiumDetailEntity: Codable {
    let id: Int
    let name, description, businessName, ceoName: String
    let contact, address: String
    let stadiumImageUrls: [String]
    let outdoorCourts, indoorCourts: [Court]
    let matchID: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, description, businessName, ceoName, contact, address, stadiumImageUrls, outdoorCourts, indoorCourts
        case matchID = "matchId"
    }
    
    func toDomain() -> StadiumDetailModel {
        var outdoorCourts: [CourtModel] = []
        var indoorCourts: [CourtModel] = []
        self.outdoorCourts.forEach {
            outdoorCourts.append(CourtModel(id: $0.id, type: $0.type, price: $0.price, imageURL: $0.imageURL))
        }
        self.indoorCourts.forEach {
            indoorCourts.append(CourtModel(id: $0.id, type: $0.type, price: $0.price, imageURL: $0.imageURL))
        }
        return StadiumDetailModel(id: self.id, name: self.name, description: self.description, businessName: self.businessName, ceoName: self.ceoName, contact: self.contact, address: self.address, stadiumImageUrls: self.stadiumImageUrls, outdoorCourts: outdoorCourts, indoorCourts: indoorCourts, matchID: self.matchID ?? 0)
    }
}

// MARK: - Court
struct Court: Codable {
    let id: Int
    let type: String
    let price: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case id, type, price
        case imageURL = "imageUrl"
    }
}
