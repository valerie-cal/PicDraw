//
//  ImagePicker.swift
//  MDB-Project
//
//  Created by Brayton Lordianto on 9/30/24.
//

import Foundation
import PhotosUI
import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // Dismiss the picker and handle the selected image
            picker.dismiss(animated: true, completion: nil)
            
            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
            
            provider.loadObject(ofClass: UIImage.self) {
                [weak self] (image, error) in
                    if let im = image as? UIImage {
                        DispatchQueue.main.async {
                            self?.parent.image = im
                        }
                }
            }
        }
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        // Configure the PHPicker to select images only
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
