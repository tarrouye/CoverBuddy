//
//  BackgroundBlurView.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/18/21.
//

import SwiftUI

struct BackgroundBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
            view.backgroundColor = .clear
            view.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
