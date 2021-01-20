//
//  InstructCardView.swift
//  Cover Buddy
//
//  Created by Théo Arrouye on 1/19/21.
//

import SwiftUI

struct InstructCard {
    var title : String
    var icon : String
    var bgCol : Color
    var steps : [String]?
}

struct InstructCardView : View {
    @Environment(\.openURL) var openURL
    
    @State var currentCardIndex : Int = 0
    @Binding var cardInfo : InstructCard
    @Binding var rootIsActive : Bool
    
    @State var showingInfo : Bool = false
    
    let unsupportedMessage = "This service does not support custom playlist covers.\nIf this is something you care about, please contact or tweet at them!"
    
    let unsupportedMessage2 = "If this is no longer true, please contact us."
    
    var body : some View {
        VStack(alignment: .leading) {
            HStack {
                Image(cardInfo.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                
                Text(cardInfo.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                // For spotify only, little info popup explaining why they have to go through Desktop
                if (cardInfo.title == "Spotify (Mobile)") {
                    PillButton(label: "Help", /*systemImage: "info.circle", */bgCol: Color.blue) {
                        self.showingInfo = true
                    }
                    .alert(isPresented: $showingInfo) {
                        Alert(title: Text("I don't see 'Change Image'!"),
                            message: Text("\nSpotify's iOS app currently only supports editing playlist covers for select users.\n\nIf you are not included in this set of users, you won't see the 'Change Image' option.\n\nIf this is something you care about, please contact or tweet at Spotify asking them to make this feature available to all users!"),
                            primaryButton: .default(Text("See Spotify Source")) {
                                openURL(URL(string: "https://newsroom.spotify.com/2020-12-08/how-to-upload-a-custom-playlist-image-using-your-phone/")!)
                            },
                            secondaryButton: .default(Text("OK")))
                    }
                } else if (cardInfo.steps == nil) {
                    Menu {
                        Text(self.unsupportedMessage2)
                    } label: {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.red)
                            .font(.title2)
                    }
                }
                
            }
            
            if (cardInfo.steps != nil) {
                CarouselView(cardCount: cardInfo.steps!.count + 1, currentIndex: $currentCardIndex, showPageDots: true, bgView: AnyView(
                        cardInfo.bgCol
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    )
                ) {
                    ForEach(cardInfo.steps!.indices) { step in
                        HStack {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Step \(step + 1)")
                                    .font(.headline)
                                    .padding(.bottom)

                                    
                                
                                Text(cardInfo.steps![step])
                                    .lineLimit(4)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                    
                            }
                            
                            
                            Spacer()
                        }
                        .padding()
                    }
                    
                    RimmedRectButton(label: "All set up", systemImage: "checkmark.circle.fill") {
                        self.rootIsActive = false
                    }
                    .padding()
                }
                .frame(height: 150)
            } else {
                ZStack {
                    cardInfo.bgCol
                    
                    Text(self.unsupportedMessage)
                        .lineLimit(5)
                        .multilineTextAlignment(.leading)
                        .padding()
                }
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            }

        }
        .padding()
        .background(Color(UIColor.tertiarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
        .padding()
    }
}
