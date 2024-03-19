//
//  ImmersiveViewModel.swift
//  arpictures
//
//  Created by Andrey Grunenkov on 19.03.2024.
//

import Foundation
import _RealityKit_SwiftUI
import UIKit
import SwiftUI

@MainActor class ImmersiveViewModel: ObservableObject {
    
    @Published var isPhotoSelected = false
    @AppStorage("material") private var material: Int = 0
    @AppStorage("filter") private var filter: Int = 0
    var content: RealityViewContent?
    var lastAnchor: AnchorEntity?
    
    init() {
        NotificationCenter.default.addObserver(forName: .isPhotoSelected, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isPhotoSelected = true
            }
        }
    }
    
    func makeFrame() -> Entity {
        let frame = try! Entity.load(named: "arframe.usdz")
        return frame
    }
    
    func makePicture(_ image: UIImage?) -> Entity? {
        if let photo = makePhoto(image, isHorizontal: false) {
            return photo
        }
        return nil
    }
    
    private func makePhoto(_ photo: UIImage?, isHorizontal: Bool) -> Entity? {
        guard let photo = photo else { return nil }
        let filter = ImageFilter(rawValue: filter)
        let filtered = applyFilter(image: photo, filter: filter!)
        
        var width = 0.529
        var depth = 0.7
        if isHorizontal {
            depth = 0.529
            width = 0.7
        }
        let modelEntity = ModelEntity(
            mesh: MeshResource.generateBox(
                width: Float(width),
                height: 0.013,
                depth: Float(depth)
            )
        )
        let texture = createTexture(drawing: filtered?.cgImage)
        modelEntity.model?.materials = [texture]
        let radians = 90 * Float.pi / 180.0
        //modelEntity.transform.rotation = simd_quatf(angle: radians, axis: SIMD3(x: 0, y: 1, z: 0))
        return modelEntity
    }
    
    private func createTexture(drawing: CGImage?) -> SimpleMaterial {
        let material = MaterialType(rawValue: material)
        var metallic = false
        var semantic = TextureResource.Semantic.color
        
        switch material {
        case .normal:
            break
        case .hdcolor:
            semantic = .hdrColor
        case .metallic:
            metallic = true
        case .faded:
            semantic = .normal
        default:
            break
        }
        
        if drawing == nil {
            return SimpleMaterial(color: .white, roughness: .float(0), isMetallic: metallic)
        } else {
            let texture = try! TextureResource.generate(from: drawing!, options: .init(semantic: semantic))
            var material = SimpleMaterial()
            material.color = .init(texture: .init(texture))
            material.roughness = .float(0)
            material.metallic = .float(0)
            return material
        }
    }
    
    // Filters logic
    
    private func render(_ inputImage: UIImage,
                 brightness: Double? = nil,
                 saturation: Double? = nil,
                 contrast: Double? = nil,
                 sizeModifier: Double = 1.0
     ) -> UIImage? {
         let originalimage = inputImage
         let beginImage = CIImage(image: originalimage)
         let filter = CIFilter(name: "CIColorControls")
         filter?.setValue(beginImage, forKey: kCIInputImageKey)
         if let brightness = brightness {
             filter?.setValue(brightness, forKey: kCIInputBrightnessKey)
         }
         if let saturation = saturation {
             filter?.setValue(saturation, forKey: kCIInputSaturationKey)
         }
         if let contrast = contrast {
             filter?.setValue(contrast, forKey: kCIInputContrastKey)
         }
         if let image = filter?.outputImage {
             let size = CGSize(width: image.extent.size.width * sizeModifier, height: image.extent.size.height * sizeModifier)
             UIGraphicsBeginImageContextWithOptions(size, false, originalimage.scale * sizeModifier)
             UIImage(ciImage: image).draw(in: CGRect(origin: .zero, size: size))
             let im = UIGraphicsGetImageFromCurrentImageContext()
             UIGraphicsEndImageContext()
             return im
         }
         return nil
     }
    
    private func applyFilter(image: UIImage, filter: ImageFilter, brightness: Float = 0.5, sizeModifier: Double = 1.0, isToCrop: Bool = false) -> UIImage? {
        var filteredImage: UIImage?
        
        filteredImage = nil
        let brightness = Double(brightness - 0.5)
        let beginImage = image

        switch filter {
        case .original:
            filteredImage = render(beginImage, brightness: brightness, sizeModifier: sizeModifier)
            return filteredImage
        case .contrast:
            filteredImage = render(beginImage, brightness: brightness + 1.55, saturation: 0.9, contrast: 5.1, sizeModifier: sizeModifier)
            return filteredImage
        case .blackWhite:
            filteredImage = render(beginImage, brightness: brightness + 1.53, saturation: -0.01, contrast: 4.6, sizeModifier: sizeModifier)
            return filteredImage
        case .gray:
            filteredImage = render(beginImage, brightness: brightness + 0.53, saturation: 0.03, contrast: 2.0, sizeModifier: sizeModifier)
            return filteredImage
        case .scanner:
            filteredImage = render(beginImage, brightness: brightness + 0.792, saturation: 1.0, contrast: 2.6, sizeModifier: sizeModifier)
            return filteredImage
        }
    }
    
    private func isHorisontalPhoto() -> Bool {
        guard let photo = ImmersiveView.selectedImage else { return false }
        return photo.size.width > photo.size.height
    }
    
}
