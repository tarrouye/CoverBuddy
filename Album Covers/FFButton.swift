//
//  FFButton.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/18/21.
//

import SwiftUI

// FFButton or FastForwardButton
// A simple button with a system image framed in a circle and background color
// When click once, it increments by tapIncrement
// When held, it increments by holdIncrement every 0.1 sec
struct FFButton: View {
    @Binding var trackedValue: Int
    var tapIncrement : Int
    var holdIncrement : Int
    var minVal : Int
    var maxVal : Int
    @Binding var bgCol : Color
    
    var systemName : String
    var frameHeight : CGFloat
    var cornerRadius : CGFloat
    
    @State private var timer: Timer?
    @State private var isLongPressing = false
    
    private func adjustTrackedValue(_ by: Int) {
        self.trackedValue = max(self.minVal, min(self.maxVal, self.trackedValue + by))
    }
    
    var body: some View {
        
            Button(action: {
                if (self.isLongPressing){
                    // Longpress gesture ended
                    self.isLongPressing.toggle()
                    self.timer?.invalidate()
                    
                } else {
                    // Normal tap, increment
                    self.adjustTrackedValue(self.tapIncrement)
                }
            }, label: {
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: frameHeight)
                    .background(BackgroundBlurView().background(bgCol))
                    .clipShape(Circle())
                
            })
            .buttonStyle(PlainButtonStyle())
            .simultaneousGesture(LongPressGesture(minimumDuration: 0.2).onEnded { _ in
                self.isLongPressing = true
                
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                    self.adjustTrackedValue(self.holdIncrement)
                })
            })
    }
}
