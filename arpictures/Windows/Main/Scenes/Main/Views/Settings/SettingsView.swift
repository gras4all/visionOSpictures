//
//  SettingsView.swift
//  arpictures
//
//  Created by Andrey Grunenkov on 18.03.2024.
//

import SwiftUI

struct SettingsView: View {

    @AppStorage("material") private var material: Int = 0
    @AppStorage("filter") private var filter: Int = 0
    
    @State private var materials: [MaterialCardModel] = [
        MaterialCardModel(id: 1, value: .normal, title: "Normal", shine: .none, isSelected: false),
        MaterialCardModel(id: 2, value: .metallic, title: "Metallic", shine: .silver, isSelected: false),
        MaterialCardModel(id: 3, value: .hdcolor, title: "HD Color", shine: .bronze, isSelected: false),
        MaterialCardModel(id: 4, value: .faded, title: "Faded", shine: .none, isSelected: false),
    ]
    
    @State private var filters: [FilterCardModel] = [
        FilterCardModel(id: 1, value: .original, src: "ic_filter", isSelected: false),
        FilterCardModel(id: 2, value: .scanner, src: "ic_filter_scanner", isSelected: false),
        FilterCardModel(id: 3, value: .blackWhite, src: "ic_filter_black_white", isSelected: false),
        FilterCardModel(id: 4, value: .gray, src: "ic_filter_gray", isSelected: false),
        FilterCardModel(id: 5, value: .contrast, src: "ic_filter_contrast", isSelected: false),
    ]

    let minValue: Double = 1
    let maxValue: Double = 10
    
        var body: some View {
            NavigationView {
                ZStack {
                    Color.black.edgesIgnoringSafeArea([.all])
                    ScrollView {
                        VStack {
                            Spacer()
                                .frame(height: 20)
                            
                            VStack {
                                Text("Select material of picture:")
                                    .font(.headline)
                                    .padding(.leading, 40)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        Spacer()
                                            .frame(width: 1)
                                        ForEach(materials.indices) { index in
                                            MaterialCardView(card: $materials[index])
                                                .onTapGesture {
                                                    selectMaterial(index)
                                                }
                                        }
                                    }
                                }
                            }
                            .padding(.top, 10)
                            .padding(.bottom, 15)
                            .background(Color("LightBlack"))
                            .cornerRadius(6)
                            
                            Spacer()
                                .frame(height: 20)
                            
                            VStack {
                                Text("Select filter:")
                                    .font(.headline)
                                    .padding(.leading, 40)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 20) {
                                            Spacer()
                                                .frame(width: 1)
                                            Image(filters[0].src)
                                                .resizable()
                                                .frame(width: 75, height: 100)
                                                .cornerRadius(6)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 6)
                                                        .stroke(.accent, lineWidth: filter == 0 ? 3 : 0)
                                                )
                                                .padding(.top, 3)
                                                .padding(.bottom, 3)
                                                .onTapGesture {
                                                    selectFilter(0)
                                                }
                                            
                                            
                                            Image(filters[1].src)
                                                .resizable()
                                                .frame(width: 75, height: 100)
                                                .cornerRadius(6)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 6)
                                                        .stroke(.accent, lineWidth: filter == 1 ? 3 : 0)
                                                )
                                                    .padding(.top, 3)
                                                    .padding(.bottom, 3)
                                                    .onTapGesture {
                                                        selectFilter(1)
                                                    }
                                            
                                            
                                            
                                            Image(filters[2].src)
                                                .resizable()
                                            .frame(width: 75, height: 100)
                                            .cornerRadius(6)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 6)
                                                    .stroke(.accent, lineWidth: filter == 2 ? 3 : 0)
                                            )
                                                .padding(.top, 3)
                                                .padding(.bottom, 3)
                                                .onTapGesture {
                                                    selectFilter(2)
                                                }
                                            
                                            Image(filters[3].src)
                                                .resizable()
                                            .frame(width: 75, height: 100)
                                            .cornerRadius(6)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 6)
                                                    .stroke(.accent, lineWidth: filter == 3 ? 3 : 0)
                                            )
                                                .padding(.top, 3)
                                                .padding(.bottom, 3)
                                                .onTapGesture {
                                                    selectFilter(3)
                                                }
                                            
                                            Image(filters[4].src)
                                                .resizable()
                                            .frame(width: 75, height: 100)
                                            .cornerRadius(6)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 6)
                                                    .stroke(.accent, lineWidth: filter == 4 ? 3 : 0)
                                            )
                                                .padding(.top, 3)
                                                .padding(.bottom, 3)
                                                .onTapGesture {
                                                    selectFilter(4)
                                                }
                                            Spacer()
                                                .frame(width: 1)
                                            
                                        
                                    }
                                }
                            }
                            .padding(.top, 7)
                            .padding(.bottom, 12)
                            .background(Color("LightBlack"))
                            .cornerRadius(6)
 
                            Spacer()
                                .frame(height: 60)
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                    }
                }
                .navigationBarTitle("Settings")
            }
            .onAppear() {
                materials.indices.forEach { i in
                    materials[i].isSelected = i == material
                }
                filters.indices.forEach { i in
                    filters[i].isSelected = i == filter
                }
            }
        }
    
    private func selectMaterial(_ index: Int) {
        material = index
        withAnimation {
            materials.indices.forEach { i in
                materials[i].isSelected = i == index
            }
        }
    }
    
    private func selectFilter(_ index: Int) {
        filter = index
        withAnimation {
            filters.indices.forEach { i in
                filters[i].isSelected = i == index
            }
        }
    }
    
    
}

#Preview {
    SettingsView()
}

