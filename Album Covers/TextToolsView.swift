//
//  TextToolsView.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/12/21.
//

import SwiftUI

struct TextToolsView : View {
    @Binding var colPickTitle : String
    @State var colPickDefaultTitle : String
    @Binding var colPicked : Color
    @Binding var fontDisplayName : String?
    @Binding var fontPostscriptName : String?
    @Binding var fontSize : Int
    @Binding var textAlignment : NSTextAlignment
    @Binding var textYPos : CGFloat
    
    @State var isShowingFontPicker : Bool = false
    
    var rounding : CGFloat
    
    var chunkHeight : CGFloat = 35
    
    var body : some View {
        GeometryReader { geometry in
            VStack {
                // Color Picker
                ColorPicker(colPickTitle.isEmpty ? colPickDefaultTitle : colPickTitle, selection: $colPicked, supportsOpacity: true)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .frame(height: chunkHeight)
                    .background(BackgroundBlurView().background(colPicked))
                    .clipShape(RoundedRectangle(cornerRadius: rounding * 0.75, style: .continuous))
                
                // Font Picker
                Button(action: {
                    self.isShowingFontPicker = true
                }) {
                    Text(fontDisplayName ?? "Select a font")
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: chunkHeight)
                        .background(BackgroundBlurView().background(colPicked))
                        .clipShape(RoundedRectangle(cornerRadius: rounding * 0.75, style: .continuous))
                }
                .buttonStyle(PlainButtonStyle())
                .sheet(isPresented: self.$isShowingFontPicker) {
                    VStack {
                        HStack {
                            PillButton(label: "Cancel") {
                                self.isShowingFontPicker = false
                            }
                            
                            Spacer()
                        }
                        .padding()
                        
                        FontPicker(postscriptName: $fontPostscriptName, family: $fontDisplayName)
                    }
                }
                
                // Font Size
                
                HStack {
                    FFButton(trackedValue: $fontSize, tapIncrement: -6, holdIncrement: -6, minVal: 12, maxVal: 450, bgCol: $colPicked, systemName: "minus.circle", frameHeight: chunkHeight, cornerRadius: rounding)
                    
                    Spacer()
                    
                    Text("Font size: \(fontSize)")
                        .font(.body)
                        .padding(.vertical)
                    
                    Spacer()
                    
                    FFButton(trackedValue: $fontSize, tapIncrement: 6, holdIncrement: 6, minVal: 12, maxVal: 450, bgCol: $colPicked, systemName: "plus.circle", frameHeight: chunkHeight, cornerRadius: rounding)
                    
                }
                .frame(maxWidth: .infinity)
                
                // Horizontal Alignment
                HStack {
                    Button(action: {
                        textAlignment = .left
                    }) {
                        Image(systemName: "text.alignleft")
                            .font(Font.body.weight((textAlignment == .left) ? .bold : .regular))
                            .padding(.vertical)
                            .frame(width: (geometry.size.width - 20) / 3, height: chunkHeight)
                            .background(BackgroundBlurView().background(colPicked))
                            .clipShape(RoundedRectangle(cornerRadius: rounding * 0.75, style: .continuous))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    Button(action: {
                        textAlignment = .center
                    }) {
                        Image(systemName: "text.aligncenter")
                            .font(Font.body.weight((textAlignment == .center) ? .bold : .regular))
                            .padding(.vertical)
                            .frame(width: (geometry.size.width - 20) / 3, height: chunkHeight)
                            .background(BackgroundBlurView().background(colPicked))
                            .clipShape(RoundedRectangle(cornerRadius: rounding * 0.75, style: .continuous))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    Button(action: {
                        textAlignment = .right
                    }) {
                        Image(systemName: "text.alignright")
                            .font(Font.body.weight((textAlignment == .right) ? .bold : .regular))
                            .padding(.vertical)
                            .frame(width: (geometry.size.width - 20) / 3, height: chunkHeight)
                            .background(BackgroundBlurView().background(colPicked))
                            .clipShape(RoundedRectangle(cornerRadius: rounding * 0.75, style: .continuous))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .frame(maxWidth: .infinity)
                
                
                // Vertical Alignment
                HStack {
                    Button(action: {
                        textYPos = CGFloat(fontSize) / 2
                    }) {
                        Image(systemName: "chevron.up.circle.fill")
                            .font(Font.body.weight((textAlignment == .left) ? .bold : .regular))
                            .padding(.vertical)
                            .frame(width: (geometry.size.width - 20) / 3, height: chunkHeight)
                            .background(BackgroundBlurView().background(colPicked))
                            .clipShape(RoundedRectangle(cornerRadius: rounding * 0.75, style: .continuous))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    Button(action: {
                        textYPos = 750
                    }) {
                        Image(systemName: "square.split.1x2.fill")
                            .font(Font.body.weight((textAlignment == .center) ? .bold : .regular))
                            .padding(.vertical)
                            .frame(width: (geometry.size.width - 20) / 3, height: chunkHeight)
                            .background(BackgroundBlurView().background(colPicked))
                            .clipShape(RoundedRectangle(cornerRadius: rounding * 0.75, style: .continuous))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    Button(action: {
                        textYPos = 1500 - CGFloat(fontSize) / 2
                    }) {
                        Image(systemName: "chevron.down.circle.fill")
                            .font(Font.body.weight((textAlignment == .right) ? .bold : .regular))
                            .padding(.vertical)
                            .frame(width: (geometry.size.width - 20) / 3, height: chunkHeight)
                            .background(BackgroundBlurView().background(colPicked))
                            .clipShape(RoundedRectangle(cornerRadius: rounding * 0.75, style: .continuous))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .frame(maxWidth: .infinity)
    
            }
            .frame(maxWidth: .infinity)
        }
    }
}
