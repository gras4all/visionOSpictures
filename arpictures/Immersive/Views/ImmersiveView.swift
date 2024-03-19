//
//  ImmersiveView.swift
//  arpictures
//
//  Created by Andrey Grunenkov on 18.03.2024.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    
    static var selectedImage: UIImage?
    var realityContent: RealityViewContent?
    
    @StateObject var model = ImmersiveViewModel()
    
    var body: some View {
        RealityView { content in
            model.content = content
        }
        .onReceive(model.$isPhotoSelected ) { isSelected in
            if isSelected {
                let pictureAnchor = AnchorEntity(.plane(.vertical, classification: .any, minimumBounds: SIMD2<Float>(0.5, 0.5)))
                if let photo = model.makePicture(ImmersiveView.selectedImage) {
                    //photo.position = SIMD3(x: 0, y: 0, z: 0)
                    pictureAnchor.addChild(
                        photo
                    )
                }
                model.lastAnchor?.removeFromParent()
                model.content?.add(pictureAnchor)
                model.lastAnchor = pictureAnchor
            }
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
}
