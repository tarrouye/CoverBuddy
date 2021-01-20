//
//  RimmedRectView.swift
//  Cover Buddy
//
//  Created by Théo Arrouye on 1/20/21.
//

import SwiftUI

struct RimmedRectButton: View {
    var label : String
    var systemImage : String
    var backgroundCol : Color = Color(UIColor.secondarySystemGroupedBackground)
    var foregroundCol : Color = Color(UIColor.label)
    var rimCol : Color = Color(UIColor.label)
    
    var action : (() -> Void)?
    
    var body: some View {
        Button(action: { if (self.action != nil) { self.action!() } }) {
            Label(self.label, systemImage: self.systemImage)
                .foregroundColor(self.foregroundCol)
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(self.backgroundCol)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous).inset(by: 1))
                .padding(1)
                .background(self.rimCol)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
        .buttonStyle(PlainButtonStyle())
    }
}
