//
//  DrawingViewModel.swift
//  MDB-Project
//
//  Created by Brayton Lordianto on 9/30/24.
//

import Foundation
import UIKit
import PencilKit

struct DrawingModel {
    var canvas: PKCanvasView
    var name: String
    var isSelected: Bool = false
    var overlaidImages = [overlaidImage]()
    var idImage = UIImage()

    struct overlaidImage {
        // Define properties for an image, its position (center), scale, and rotation
        var image: UIImage
        var position: CGPoint
        var scale: CGFloat
        var rotation: CGFloat
    }

    init() {
        self.canvas = .init()
        self.name = "untitled"
    }
}

extension DrawingModel {
    mutating func overlayImage(image: UIImage) -> DrawingModel {
        // Implement adding an image as a subview to the canvas
        let overlay = overlaidImage(image: image, position: CGPoint.zero, scale: 1.0, rotation: 0.0)
        overlaidImages.append(overlay)
        return DrawingModel()
    }
    
    func createExportableView() -> UIView {
        // Implement logic to capture the canvas and create a snapshot image
        let snapshot = canvas.snapshotView(afterScreenUpdates: true)!
        return snapshot
    }
}

class DrawingViewModel: ObservableObject {
    @Published var drawing = DrawingModel()
}
