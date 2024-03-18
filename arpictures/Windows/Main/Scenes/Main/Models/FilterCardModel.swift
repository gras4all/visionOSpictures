//
//  FilterCardModel.swift
//  arpictures
//
//  Created by Andrey Grunenkov on 18.03.2024.
//


import Foundation
import UIKit
import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

enum ImageFilter: Int {
    case original
    case scanner
    case blackWhite
    case gray
    case contrast
}

struct FilterCardModel: Identifiable {
    let id: Int
    let value: ImageFilter
    let src: String
    var isSelected: Bool
}

