//
//  PillButton.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/11/21.
//

import SwiftUI

struct PillButton : View {
    var label : String?
    var systemImage : String?
    var bgCol : Color = Color(UIColor.tertiarySystemGroupedBackground)
    
    var action : (() -> Void)?
    
    var body: some View {
        Group {
            if (self.label != nil) {
                Text(self.label!)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(self.bgCol)
                    .cornerRadius(15)
            } else if (self.systemImage != nil) {
                Image(systemName: self.systemImage!)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(self.bgCol)
                    .cornerRadius(15)
            }
        }
        .onTapGesture {
            if (self.action != nil) {
                self.action!()
            }
        }
    }
}
