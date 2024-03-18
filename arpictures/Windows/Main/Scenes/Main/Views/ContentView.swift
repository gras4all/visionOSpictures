//
//  ContentView.swift
//  arpictures
//
//  Created by Andrey Grunenkov on 18.03.2024.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        HStack(spacing: 16) {
            VStack {
                Text("Gallery")
                    .foregroundColor(.white)
                    .font(.title)
                LibraryView()
            }
            .padding(.top, 30)
            .background(.containerBg)
            .cornerRadius(30)
            VStack {
                Text("Settings")
                    .foregroundColor(.white)
                    .font(.title)
                SettingsView()
            }
            .padding(.top, 30)
            .background(.containerBg)
            .cornerRadius(30)
        }
        .padding()
        .task {
            Task {
                switch await openImmersiveSpace(id: "ImmersiveSpace") {
                case .opened:
                    immersiveSpaceIsShown = true
                case .error, .userCancelled:
                    fallthrough
                @unknown default:
                    immersiveSpaceIsShown = false
                    showImmersiveSpace = false
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
