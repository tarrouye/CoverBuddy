//
//  SpicyStack.swift
//  Cover Buddy
//
//  Created by Théo Arrouye on 1/19/21.
//

import SwiftUI

// A Stack that automatically switches between HStack and VStack depending on device rotation/window size
struct SpicyStack<Content: View> : View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body : some View {
        GeometryReader { proxy in
            if (proxy.size.width > proxy.size.height) {
                HStack(alignment: .center) {
                    self.content
                }.frame(width: proxy.size.width, height: proxy.size.height)
            } else {
                VStack(alignment: .center) {
                    self.content
                }.frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
    }
}
