//
//  CoverEditView.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/9/21.
//

// TODO: Localize strings .. everywhere

import SwiftUI

struct MyTextField : View {
    var placeholder : String
    @Binding var text : String
   
    @Binding var alignment: NSTextAlignment
    
    var body : some View {
        HStack {
            if (alignment == .right || alignment == .center) {
                Spacer()
            }
            
            TextField(placeholder, text: $text)
                .multilineTextAlignment((alignment == .left) ? .leading : ((alignment == .right) ? .trailing : .center))
                .background(text.isEmpty ? Color.white.opacity(0.5) : Color.clear)
                .fixedSize()
            
            if (alignment == .left || alignment == .center) {
                Spacer()
            }
        }
    }
}

struct CoverEditView: View {
    @StateObject var model = CoverEditViewModel()
    
    @Binding var rootIsActive : Bool
    
    private var passedValue : Any
    
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
                    VStack(alignment: .center) {
                        // Preview
                        ZStack {
                            // background image
                            Image(model.backgroundImage!)
                                .resizable()
                                .scaledToFit()
                                
                            
                            // Text box one
                            HStack {
                                // Simulate sidePadding
                                Spacer()
                                    .frame(width: model.sidePadding(geometry))
                                
                                VStack {
                                    // Use spacers to position text as it would be from parameters
                                    Spacer()
                                        .frame(height: model.topPosition(geometry))
                                    
                                    MyTextField(placeholder: "Text One", text: $model.topText, alignment: $model.topTextAlignment)
                                        .font(model.topFont(geometry))
                                        .foregroundColor(model.topCol)
                                        .frame(width: model.textFieldWidth(geometry), height: model.topFontHeight(geometry), alignment: model.topFrameAlignment)
                                        .simultaneousGesture(DragGesture(minimumDistance: 0.2).onChanged { gesture in
                                            model.topPos = min(max(CGFloat(model.topFontSize / 2), model.topPos + gesture.translation.height), 1500 - CGFloat(model.topFontSize / 2))
                                        })
                                    
                                    Spacer()
                                        .frame(height: model.coverSize(geometry) - model.topPosition(geometry))
                                }
                                
                                // Simulate sidePadding
                                Spacer()
                                    .frame(width: model.sidePadding(geometry))
                            }

                                
                            // Text box two
                            HStack {
                                // Simulate sidePadding
                                Spacer()
                                    .frame(width: model.sidePadding(geometry))
                                
                                VStack {
                                    // Use spacers to position text as it would be from parameters
                                    Spacer()
                                        .frame(height: model.botPosition(geometry))
                                    
                                    MyTextField(placeholder: "Text Two", text: $model.botText, alignment: $model.botTextAlignment)
                                        .font(model.botFont(geometry))
                                        .foregroundColor(model.botCol)
                                        .frame(width: model.textFieldWidth(geometry), height: model.botFontHeight(geometry), alignment: model.botFrameAlignment)
                                        .simultaneousGesture(DragGesture(minimumDistance: 0.2).onChanged { gesture in
                                            model.botPos = min(max(CGFloat(model.botFontSize / 2), model.botPos + gesture.translation.height), 1500 - CGFloat(model.botFontSize / 2))
                                        })
                                    
                                    Spacer()
                                        .frame(height: model.coverSize(geometry) - model.botPosition(geometry))
                                        
                                }
                                
                                // Simulate sidePadding
                                Spacer()
                                    .frame(width: model.sidePadding(geometry))
                            }
                        }
                        .frame(width: model.coverSize(geometry), height: model.coverSize(geometry), alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: rounding, style: .continuous))
                        .shadow(radius: 35)
                        .padding(.top, 25)
                    
                    
                    
                    
                    
                    
                        // Editing tools

                        HStack {

                            TextToolsView(colPickTitle: $model.topText, colPickDefaultTitle: "Text one", colPicked: $model.topCol, fontDisplayName: $model.topFontDisplayName, fontPostscriptName: $model.topFontName, fontSize: $model.topFontSize, textAlignment: $model.topTextAlignment, rounding: rounding)
                                .frame(width: model.coverSize(geometry) / 2 - 10)
                                .padding(.trailing, 5)

                            Divider()

                            TextToolsView(colPickTitle: $model.botText, colPickDefaultTitle: "Text two", colPicked: $model.botCol, fontDisplayName: $model.botFontDisplayName, fontPostscriptName: $model.botFontName, fontSize: $model.botFontSize, textAlignment: $model.botTextAlignment, rounding: rounding)
                                .frame(width: model.coverSize(geometry) / 2 - 10)
                                .padding(.leading, 5)

                        }

                        .frame(width: model.coverSize(geometry))


                        Spacer()

                        // Export button
                        Button(action: saveAction) {
                            Label(model.isNew ? "Add to Library" : "Update Cover", systemImage: "arrow.2.circlepath.circle.fill")
                                .foregroundColor(model.buttonLabelColor)
                                .font(.headline)
                                .padding()
                                .frame(width: model.coverSize(geometry))
                                .background(model.dominantImageColor)
                                .clipShape(RoundedRectangle(cornerRadius: rounding * 0.75, style: .continuous).inset(by: 1))
                                .padding(1)
                                .background(model.buttonLabelColor)
                                .clipShape(RoundedRectangle(cornerRadius: rounding * 0.75, style: .continuous))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.bottom)
                        
                        
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

struct CoverEditView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello World")
    }
}

