//
//  PillButton.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/11/21.
//

import SwiftUI

// Simple Pill shaped button
struct PillButton : View {
    var label : String?
    var systemImage : String?
    var bgCol : Color = Color(UIColor.tertiarySystemGroupedBackground)
    
    var action : (() -> Void)?
    
    var body: some View {
        HStack {
            if (self.systemImage != nil) {
                Image(systemName: self.systemImage!)
                    .padding(self.label != nil ? .leading : .horizontal, 8)
                    
            }
            
            if (self.label != nil) {
                Text(self.label!)
                    .fontWeight(.semibold)
                    .padding(self.systemImage != nil ? .trailing : .horizontal, 10)
            }
        }
        .padding(.vertical, 5)
        .background(self.bgCol)
        .cornerRadius(15)
        .onTapGesture {
            if (self.action != nil) {
                self.action!()
            }
        }
    }
}
