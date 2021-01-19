//
//  MyTextField.swift
//  Cover Buddy
//
//  Created by Théo Arrouye on 1/19/21.
//

import SwiftUI

struct MyTextField : View {
    var placeholder : String
    @ObservedObject var textBindingManager : TextBindingManager
   
    @Binding var alignment: NSTextAlignment

    var body : some View {
        HStack {
            if (alignment == .right || alignment == .center) {
                Spacer()
            }
            
            TextField(placeholder, text: $textBindingManager.text)
                .multilineTextAlignment((alignment == .left) ? .leading : ((alignment == .right) ? .trailing : .center))
                .background(textBindingManager.text.isEmpty ? Color.white.opacity(0.5) : Color.clear)
            
            if (alignment == .left || alignment == .center) {
                Spacer()
            }
        }
    }
}
