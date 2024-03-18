//
//  MaterialCardModel.swift
//  arpictures
//
//  Created by Andrey Grunenkov on 18.03.2024.
//

import Foundation

enum MaterialType: Int {
    case normal
    case metallic
    case hdcolor
    case faded
}

struct MaterialCardModel: Identifiable {
    let id: Int
    let value: MaterialType
    let title: String
    let shine: ShineColor
    var isSelected: Bool
}

