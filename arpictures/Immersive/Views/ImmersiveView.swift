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
    
    @State var pictureEntity: Entity = {
        let pictureAnchor = AnchorEntity(.plane(.vertical, classification: .any, minimumBounds: SIMD2<Float>(0.5, 0.5)))
        let sphere = ModelEntity(
                        mesh: .generateSphere(radius: 0.1),
                        materials: [SimpleMaterial(color: .white, isMetallic: true)])

        // Enable interactions on the entity.
        sphere.components.set(InputTargetComponent())
        sphere.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.1)]))
        
        /*let bottleEntity = try! Entity.load(named: "bottle3.usdz")
        bottleEntity.addChild(labelEntity)
                
        bottleEntity.position = [0, 0, 0]
        bottleEntity.name = "bottle_label"
        let collisionComponent = CollisionComponent(shapes: [ShapeResource.generateBox(width: 0.3, height: 0.3, depth: 0.3)])
        bottleEntity.components.set(collisionComponent)
        bottleEntity.components.set(InputTargetComponent())
        pictureAnchor.addChild(bottleEntity)*/
        pictureAnchor.addChild(sphere)
        return pictureAnchor
    }()

    
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            model.content = content
        } update: { content in
            print("update")
        }
        .onReceive(model.$isPhotoSelected ) { isSelected in
            if isSelected {
                let pictureAnchor = AnchorEntity(.plane(.vertical, classification: .any, minimumBounds: SIMD2<Float>(0.5, 0.5)))
                pictureAnchor.addChild(
                    model.makeFrame()
                )
                if let photo = model.makePicture(ImmersiveView.selectedImage) {
                    pictureAnchor.addChild(
                        photo
                    )
                }
                model.content?.add(pictureAnchor)
            }
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
}
