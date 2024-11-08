//
//  CanvasView.swift
//  MDB-Project
//
//  Created by Brayton Lordianto and Amol Budhiraja on 9/30/24.
//

import SwiftUI
import PencilKit

struct CanvasView: View {
    @Binding var drawing: DrawingModel
    @State var imageToOverlay: UIImage? = nil
    @State var takingPhoto: Bool = false
    @State private var isShowingShareSheet = false
    @State private var imageToShare: UIImage? = nil

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Spacer()
                // Add buttons for camera, eraser, and export here
                Button(action: {takingPhoto = true}) {
//                    Label(systemImage: "camera.circle.fill")
                    Image(systemName: "camera")
                }
                .padding()
                Button(action: {drawing = DrawingModel()}) {
//                    Label(systemImage: "eraser")
                    Image(systemName: "eraser")
                }
                .padding()
                Button(action: {
                    let exportableView = drawing.createExportableView()
//                        imageToShare = drawing.createExportableView()
                        
                        imageToShare = convertViewToImage(exportableView)
                        //                    if let viewToShare = viewToShare {
                        //                        shareViewAsImage(viewToShare)
                        //                    }
                        //                }) {
                        isShowingShareSheet = true
                    
                }) {
//                    Label(systemImage: "square.and.arrow.up")
                    Image(systemName: "square.and.arrow.up")
                }
//                Button(action: {
//                    let exportableView = drawing.createExportableView()
//                    shareViewAsImage(exportableView)
//                }
//                }) {
//                    Image(systemName: "square.and.arrow.up")
//                }
                
                Spacer()
            }

            DrawSpace(drawing: $drawing)
                .edgesIgnoringSafeArea(.top)
        }
        .sheet(isPresented: $takingPhoto) {
            // Display ImagePicker when the camera is tapped
            ImagePicker(image: $imageToOverlay)
        }
        .onChange(of: imageToOverlay) { oldValue, newValue in
            // Implement logic to overlay selected image onto the canvas
            if let image = newValue {
                drawing = drawing.overlayImage(image: image)
            }
        }
        .sheet(isPresented: $isShowingShareSheet) {
            // Present the share sheet with the generated image
            if let imageToShare = imageToShare {
                ShareSheet(activityItems: [imageToShare])
            }
        }
    }
    
    private func convertViewToImage(_ view: UIView) -> UIImage? {
        let render = UIGraphicsImageRenderer(size: view.bounds.size)
        return render.image{ _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }
}

// ShareSheet Struct to Present UIActivityViewController
struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// Preview Provider
#Preview {
    CanvasView(drawing: .constant(DrawingModel.init()))
}
