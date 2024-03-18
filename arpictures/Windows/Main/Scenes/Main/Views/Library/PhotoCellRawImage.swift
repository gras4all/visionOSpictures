//
//  PhotoCellRawImage.swift
//  arpictures
//
//  Created by Andrey Grunenkov on 18.03.2024.
//

import SwiftUI
import Photos
import PhotosUI

struct PhotoCellRawImage: View {
    let rawImage: UIImage

    var body: some View {
        Image(uiImage: rawImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: LibraryView.side, height: LibraryView.side) // Adjust the size as needed
            .clipShape(Rectangle()) // or Circle() for a circular shape
            .overlay(Rectangle().stroke(Color.lightBlack, lineWidth: 1))
            .shadow(radius: 5)
    }
}


