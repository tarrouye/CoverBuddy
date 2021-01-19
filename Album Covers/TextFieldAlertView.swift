//
//  TextFieldAlertView.swift
//  Cover Buddy
//
//  Created by Théo Arrouye on 1/19/21.
//

import SwiftUI

struct TextFieldAlertView : View {
    @ObservedObject var textBindingManager1 : TextBindingManager
    @ObservedObject var textBindingManager2 : TextBindingManager
    
    var body : some View {
        Group {
            if (textBindingManager1.alertMessage != nil || textBindingManager2.alertMessage != nil) {
                Text(textBindingManager1.alertMessage ?? textBindingManager2.alertMessage!)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 2)
                    .background(BackgroundBlurView().background(Color.red.opacity(0.5)).clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous)))
                    .transition(.scale)
            }
        }
    }
}
