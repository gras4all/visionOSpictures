//
//  LibraryView.swift
//  arpictures
//
//  Created by Andrey Grunenkov on 18.03.2024.
//

import SwiftUI
import Photos
import PhotosUI

struct LibraryView: View {
    
    static var side: CGFloat = 0
    static var firstImage: PHAsset?
    
    @State private var assets: [PHAsset] = []
    @State private var placeholderImages: [UIImage] = []
    @State private var showingSheet = false
    @State private var selectedPhotos: [UIImage] = []
    @State private var isImagePickerPresented: Bool = false
    
    init() {
        LibraryView.side = 180
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 16) {
                        if !assets.isEmpty {
                            ForEach(assets, id: \.localIdentifier) { asset in
                                PhotoCell(asset: asset)
                                    .onTapGesture {
                                        let requestOptions = PHImageRequestOptions()
                                        requestOptions.isSynchronous = true
                                        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: requestOptions) { (image, _) in
                                            guard let image = image else { return }
                                            handleImage(image: image)
                                        }
                                        
                                    }
                            }
                        } else {
                            ForEach(placeholderImages, id: \.self) { image in
                                PhotoCellRawImage(rawImage: image)
                                    .onTapGesture {
                                        handleImage(image: image)
                                    }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            requestPhotos()
        }
    }
    
    private func requestPhotos() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in
            switch status {
                case .authorized:
                   fetchPhotos()
                case .limited:
                   break
                case .restricted:
                   break
                case .denied:
                   addPlaceholderPhotos()
                   break
                case .notDetermined:
                    break
                @unknown default:
                    break
                }
        }
    }

    private func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        //fetchOptions.fetchLimit = 51

        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        var fetchedAssets: [PHAsset] = []

        fetchResult.enumerateObjects { (asset, _, _) in
            if LibraryView.firstImage == nil {
                LibraryView.firstImage = asset
            }
            fetchedAssets.append(asset)
        }
        DispatchQueue.main.async {
            self.assets = fetchedAssets
            if fetchedAssets.isEmpty {
                addPlaceholderPhotos()
            }
        }
    }
    
    private func addPlaceholderPhotos() {
        self.placeholderImages = [
            UIImage(named: "ic_ph_1")!,
            UIImage(named: "ic_ph_2")!,
            UIImage(named: "ic_ph_3")!,
            UIImage(named: "ic_ph_4")!,
            UIImage(named: "ic_ph_5")!,
            UIImage(named: "ic_ph_6")!,
            UIImage(named: "ic_ph_7")!,
            UIImage(named: "ic_ph_8")!,
            UIImage(named: "ic_ph_9")!,
            UIImage(named: "ic_ph_10")!
        ]
    }
    
    private func handleImage(image: UIImage) {
        ImmersiveView.selectedImage = image
        NotificationCenter.default.post(name: .isPhotoSelected, object: nil)
    }
    
}

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedPhotos: [UIImage]
    @Binding var isImagePickerPresented: Bool

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    class Coordinator: PHPickerViewControllerDelegate {
        var parent: PhotoPicker

        init(parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.isImagePickerPresented = false

            for result in results {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            //parent.selectedPhotos.append(image)
                        }
                    }
                }
            }
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}

