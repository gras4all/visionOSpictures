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
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
}
