//
//  FontPicker.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/11/21.
//

import UIKit
import SwiftUI

// Wrap UIFontPickerController
// TODO: Figure out why this doesnt show the search bar or the dismiss button when presented as a sheet
struct FontPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var postscriptName: String?
    @Binding var family: String?
    
    func makeUIViewController(context: Context) -> UIFontPickerViewController {
        let config = UIFontPickerViewController.Configuration()
        config.includeFaces = true
        
        let viewController = UIFontPickerViewController(configuration: config)
        viewController.delegate = context.coordinator
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIFontPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIFontPickerViewControllerDelegate {
        var parent: FontPicker
        
        init(_ parent: FontPicker) {
            self.parent = parent
        }
        
        func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
            guard let descriptor = viewController.selectedFontDescriptor else { return }
            
            parent.postscriptName = descriptor.postscriptName
            parent.family = UIFont(descriptor: descriptor, size: 17).familyName
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func fontPickerViewControllerDidCancel(_ viewController: UIFontPickerViewController) {
            // canceled
        }
    }
}
