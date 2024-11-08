//
//  DraggableImageView.swift
//  MDB-Project
//
//  Created by Brayton Lordianto and Amol Budhiraja on 9/30/24.
//

import SwiftUI

class DraggableImageView: UIImageView {
    var beganPoint: CGPoint? = nil
    var originCenter: CGPoint? = nil

    override init(image: UIImage?) {
        super.init(image: image)
        setupGestureRecognizers()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGestureRecognizers()
    }

    private func setupGestureRecognizers() {
        // Set up gesture recognizers for pinch, rotate, and long press
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        addGestureRecognizer(pinchGestureRecognizer)
        
        let rotateGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
        addGestureRecognizer(rotateGestureRecognizer)
        
        let longPressGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        addGestureRecognizer(longPressGestureRecognizer)
    }

    @objc func handlePinch(_ gestureRecognizer: UIPinchGestureRecognizer) {
        // Implement pinch scaling logic
        guard gestureRecognizer.view != nil else { return }
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            gestureRecognizer.view?.transform = gestureRecognizer.view!.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale)
            gestureRecognizer.scale = 1.0
        }
    }

    @objc func handleRotation(_ gestureRecognizer: UIRotationGestureRecognizer) {
        // Implement rotation logic
        guard gestureRecognizer.view != nil else { return }
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            gestureRecognizer.view?.transform = (gestureRecognizer.view?.transform.rotated(by: gestureRecognizer.rotation))!
            gestureRecognizer.rotation = 0
        }}

    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        // Implement long press logic to remove image
        if gestureRecognizer.state == .began {
            self.removeFromSuperview()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Capture the initial touch point
        if let touch = touches.first {
            beganPoint = touch.location(in: self.superview)
            originCenter = self.center
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Implement logic for moving the image
        if let touch = touches.first, let beganPoint = beganPoint, let originCenter = originCenter {
            let currentPoint = touch.location(in: self.superview)
            let offsetX = currentPoint.x - beganPoint.x
            let offsetY = currentPoint.y - beganPoint.y
            
            self.center = CGPoint(x: originCenter.x + offsetX, y: originCenter.y + offsetY)
        }
    }
}
