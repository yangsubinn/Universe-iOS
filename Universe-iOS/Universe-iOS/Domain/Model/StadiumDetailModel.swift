//
//  StadiumDetailModel.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/02/01.
//

import Foundation

struct StadiumDetailModel {
    let id: Int
    let name, description, businessName, ceoName: String
    let contact, address: String
    let stadiumImageUrls: [String]
    let outdoorCourts, indoorCourts: [CourtModel]
    let matchID: Int
}

struct CourtModel {
    let id: Int
    let type: String
    let price: String
    let imageURL: String
}
