//
//  CoverEditView.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/9/21.
//

// TODO: Localize strings .. everywhere

import SwiftUI

struct CoverEditView: View {
    @StateObject var model = CoverEditViewModel()
    
    @Binding var rootIsActive : Bool
    
    private var passedValue : Any
    
    @State private var topGestureLastSnappedX : CGFloat = 0
    @State private var botGestureLastSnappedX : CGFloat = 0

    @State private var topGestureInitialAlignment : NSTextAlignment?
    @State private var botGestureInitialAlignment : NSTextAlignment?
    
    @State private var lastTouchedText : Int = 0

    private var alignSnapThreshold : CGFloat = 50
    
    // Initializers
    init(withProperties : CoverProperties, rootIsActive : Binding<Bool>) {
        self._rootIsActive = rootIsActive
        
        self.passedValue = withProperties
    }
    
    init(existingManagedObject : ObservedObject<Cover>, rootIsActive : Binding<Bool>) {
        self._rootIsActive = rootIsActive
        
        self.passedValue = existingManagedObject
    }
    
    
    var rounding : CGFloat = 20
    
    func initialSetup() {
        if let props = self.passedValue as? CoverProperties {
            self.model.initialize(withProperties: props)
        } else if let cover = self.passedValue as? ObservedObject<Cover> {
            self.model.initialize(withCover: cover)
        }
    }
    
    func saveAction() {
        model.exportCover()
        
        rootIsActive = false
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(UIColor.systemBackground)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                
                
                if (model.loadedData) {
                    SpicyStack {
                        // Preview
                        ZStack {
                            // background image
                            Image(model.backgroundImage!)
                                .resizable()
                                .scaledToFit()
                                
                            
                            // Text box one
                            HStack(spacing: 0) {
                                // Simulate sidePadding
                                Spacer()
                                    .frame(width: model.topLeftSidePadding(geometry))
                                    .animation(.none)
                                
                                VStack {
                                    // Use spacers to position text as it would be from parameters
                                    Spacer()
                                        .frame(height: model.topPosition(geometry))
                                    
                                    MyTextField(placeholder: "Text One", textBindingManager: model.topTextBindingManager, alignment: $model.topTextAlignment)
                                        .font(model.topFont(geometry))
                                        .foregroundColor(model.topCol)
                                        .frame(width: model.topTextFieldWidth(geometry), height: model.topFontHeight(geometry), alignment: model.topFrameAlignment)
                                        .onTapGesture {
                                            self.lastTouchedText = 0
                                        }
                                        .simultaneousGesture(DragGesture(minimumDistance: 0.2).onChanged { gesture in
                                            self.lastTouchedText = 0
                                            
                                            // vertical dragging
                                            model.topPos = min(max(CGFloat(model.topFontSize / 2), model.topPos + gesture.translation.height), 1500 - CGFloat(model.topFontSize / 2))
                                            
                                            // horizontal dragging w/ alignment snapping (somewhat janky :^D)
                                            let gesture_x = gesture.location.x / model.coverSize(geometry)
                                            
                                            if (topGestureInitialAlignment == nil) {
                                                self.topGestureInitialAlignment = model.topTextAlignment
                                                self.topGestureLastSnappedX = gesture_x
                                            } else {
                                                if (abs(gesture_x - self.topGestureLastSnappedX) > 0.1) {
                                                    var targetAlignment = model.topTextAlignment
                                                    
                                                    if (topGestureInitialAlignment == .right) {
                                                        if (gesture.translation.width < -(self.alignSnapThreshold * 2)) {
                                                            targetAlignment = .left
                                                        } else if (gesture.translation.width < -self.alignSnapThreshold) {
                                                            targetAlignment = .center
                                                        } else {
                                                            targetAlignment = .right
                                                        }
                                                    } else if (topGestureInitialAlignment == .center) {
                                                        if (gesture.translation.width < -self.alignSnapThreshold) {
                                                            targetAlignment = .left
                                                        } else if (gesture.translation.width > self.alignSnapThreshold) {
                                                            targetAlignment = .right
                                                        } else {
                                                            targetAlignment = .center
                                                        }
                                                    } else if (topGestureInitialAlignment == .left) {
                                                        if (gesture.translation.width > self.alignSnapThreshold * 2) {
                                                            targetAlignment = .right
                                                        } else if (gesture.translation.width > self.alignSnapThreshold) {
                                                            targetAlignment = .center
                                                        } else {
                                                            targetAlignment = .left
                                                        }
                                                    }
                                                    
                                                    if (model.topTextAlignment != targetAlignment) {
                                                        withAnimation {
                                                            model.topTextAlignment = targetAlignment
                                                        }
                                                    }
                                                    
                                                    self.topGestureLastSnappedX = gesture_x
                                                }
                                            }
                                        }
                                        .onEnded { gesture in
                                            self.topGestureInitialAlignment = nil
                                        })
                                    
                                    Spacer()
                                        .frame(height: model.coverSize(geometry) - model.topPosition(geometry))
                                }
                                
                                // Simulate sidePadding
                                Spacer()
                                    .frame(width: model.topRightSidePadding(geometry))
                                    .animation(.none)
                            }
                            .frame(width: model.coverSize(geometry))

                                
                            // Text box two
                            HStack(spacing: 0) {
                                // Simulate sidePadding
                                Spacer()
                                    .frame(width: model.botLeftSidePadding(geometry))
                                
                                VStack {
                                    // Use spacers to position text as it would be from parameters
                                    Spacer()
                                        .frame(height: model.botPosition(geometry))
                                    
                                    MyTextField(placeholder: "Text Two", textBindingManager: model.botTextBindingManager, alignment: $model.botTextAlignment)
                                        .font(model.botFont(geometry))
                                        .foregroundColor(model.botCol)
                                        .frame(width: model.botTextFieldWidth(geometry), height: model.botFontHeight(geometry), alignment: model.botFrameAlignment)
                                        .onTapGesture {
                                            self.lastTouchedText = 1
                                        }
                                        .simultaneousGesture(DragGesture(minimumDistance: 0.2).onChanged { gesture in
                                            self.lastTouchedText = 1
                                            
                                            // vertical dragging
                                            model.botPos = min(max(CGFloat(model.botFontSize / 2), model.botPos + gesture.translation.height), 1500 - CGFloat(model.botFontSize / 2))
                                            
                                            // horizontal dragging w/ alignment snapping (somewhat janky :^D)
                                            let gesture_x = gesture.location.x / model.coverSize(geometry)
                                            
                                            if (botGestureInitialAlignment == nil) {
                                                botGestureInitialAlignment = model.botTextAlignment
                                                self.botGestureLastSnappedX = gesture_x
                                            } else {
                                                if (abs(gesture_x - self.botGestureLastSnappedX) > 0.1) {
                                                    var targetAlignment = model.botTextAlignment
                                                    
                                                    if (botGestureInitialAlignment == .right) {
                                                        if (gesture.translation.width < -(self.alignSnapThreshold * 2)) {
                                                            targetAlignment = .left
                                                        } else if (gesture.translation.width < -self.alignSnapThreshold) {
                                                            targetAlignment = .center
                                                        } else {
                                                            targetAlignment = .right
                                                        }
                                                    } else if (botGestureInitialAlignment == .center) {
                                                        if (gesture.translation.width < -self.alignSnapThreshold) {
                                                            targetAlignment = .left
                                                        } else if (gesture.translation.width > self.alignSnapThreshold) {
                                                            targetAlignment = .right
                                                        } else {
                                                            targetAlignment = .center
                                                        }
                                                    } else if (botGestureInitialAlignment == .left) {
                                                        if (gesture.translation.width > self.alignSnapThreshold * 2) {
                                                            targetAlignment = .right
                                                        } else if (gesture.translation.width > self.alignSnapThreshold) {
                                                            targetAlignment = .center
                                                        } else {
                                                            targetAlignment = .left
                                                        }
                                                    }
                                                    
                                                    if (model.botTextAlignment != targetAlignment) {
                                                        withAnimation {
                                                            model.botTextAlignment = targetAlignment
                                                        }
                                                    }
                                                    
                                                    self.botGestureLastSnappedX = gesture_x
                                                }
                                            }
                                        }
                                        .onEnded { gesture in
                                            self.botGestureInitialAlignment = nil
                                        })
                                    
                                    Spacer()
                                        .frame(height: model.coverSize(geometry) - model.botPosition(geometry))
                                        
                                }
                                
                                // Simulate sidePadding
                                Spacer()
                                    .frame(width: model.botRightSidePadding(geometry))
                            }
                            .frame(width: model.coverSize(geometry))
                        }
                        .frame(width: model.coverSize(geometry), height: model.coverSize(geometry), alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: rounding, style: .continuous))
                        .overlay(
                            TextFieldAlertView(textBindingManager1: model.topTextBindingManager, textBindingManager2: model.botTextBindingManager)
                                .offset(y: -model.coverSize(geometry) / 2 + 25)
                        )
                        .shadow(radius: 35)
                        .padding(.top, 25)
                    
                    
                        // Editing tools
                        VStack {
                            Spacer()
                            
                            HStack {

                                TextToolsView(colPickTitle: self.lastTouchedText == 0 ? $model.topTextBindingManager.text : $model.botTextBindingManager.text, colPickDefaultTitle: "Empty text", colPicked: self.lastTouchedText == 0 ? $model.topCol : $model.botCol, fontDisplayName: self.lastTouchedText == 0 ? $model.topFontDisplayName : $model.botFontDisplayName, fontPostscriptName: self.lastTouchedText == 0 ? $model.topFontName : $model.botFontName, fontSize: self.lastTouchedText == 0 ? $model.topFontSize : $model.botFontSize, textAlignment: self.lastTouchedText == 0 ? $model.topTextAlignment : $model.botTextAlignment, textYPos: self.lastTouchedText == 0 ? $model.topPos : $model.botPos, rounding: rounding)
                                    .frame(width: model.coverSize(geometry))
                                    .padding(.trailing, 5)

                            }
                            .frame(maxHeight: model.coverSize(geometry) * 3 / 4)
                            
                            Spacer()

                            // Export button
                            RimmedRectButton(label: model.isNew ? "Add to Library" : "Update Cover", systemImage: "arrow.2.circlepath.circle.fill", backgroundCol: model.dominantImageColor, foregroundCol: model.buttonLabelColor, rimCol: model.buttonLabelColor) {
                                self.saveAction()
                            }
                            .frame(width: model.coverSize(geometry))
                            
                            Spacer()
                        }
                        
                        
                    }
                }
                
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        PillButton(systemImage: "trash.fill") {
                            model.clearAllCustomizations()
                        }
                        
                        PillButton(label: "Reset") {
                            model.resetToInitialCoverValues()
                        }
                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard) // avoid getting pushed up by keyboard
        .onAppear {
            initialSetup()
        }
    }
}
