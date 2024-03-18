//
//  MaterialCardView.swift
//  arpictures
//
//  Created by Andrey Grunenkov on 18.03.2024.
//


import Foundation
import SwiftUI

struct MaterialCardView: View {
    @Binding var card: MaterialCardModel

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 6)
                .frame(width: 100, height: 75)
                .shine(card.isSelected ? .gold : card.shine)
                .overlay(
                    Text(card.title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                )
        }
    }
}

