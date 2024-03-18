//
//  PhotoCell.swift
//  arpictures
//
//  Created by Andrey Grunenkov on 18.03.2024.
//

import SwiftUI
import Photos
import PhotosUI

struct PhotoCell: View {
    let asset: PHAsset

    var body: some View {
        Image(uiImage: loadUIImage())
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: LibraryView.side, height: LibraryView.side) // Adjust the size as needed
            .clipShape(Rectangle()) // or Circle() for a circular shape
            .overlay(Rectangle().stroke(Color.lightBlack, lineWidth: 1))
            .shadow(radius: 5)
    }

    private func loadUIImage() -> UIImage {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        var image = UIImage()
        manager.requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: options) { (result, _) in
            if let result = result {
                image = result
            }
        }
        return image
    }
}

