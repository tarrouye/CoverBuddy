//
//  SetPlaylistInstructionsView.swift
//  Cover Buddy
//
//  Created by Théo Arrouye on 1/18/21.
//

import SwiftUI

struct InstructCard {
    var title : String
    var icon : String
    var bgCol : Color
    var steps : [String]
}

struct InstructCardView : View {
    @Environment(\.openURL) var openURL
    
    @State var currentCardIndex : Int = 0
    @Binding var cardInfo : InstructCard
    
    @State var showingInfo : Bool = false
    
    
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
                    Button(action: {
                        self.showingInfo = true
                    }) {
                        Image(systemName: "info.circle")
                    }
                    .alert(isPresented: $showingInfo) {
                        Alert(title: Text("Why don't I see these options?"),
                            message: Text("Spotify's iOS app currently only supports editing playlist covers for a select number of users as part of an ongoing server-side rollout. If you believe you are included in this set of users, click on to see Spotify's instructions on how to use this feature from your phone."),
                            primaryButton: .default(Text("See Mobile Instructions")) {
                                openURL(URL(string: "https://newsroom.spotify.com/2020-12-08/how-to-upload-a-custom-playlist-image-using-your-phone/")!)
                            },
                            secondaryButton: .default(Text("OK")))
                    }
                }
                
            }
            
            CarouselView(cardCount: cardInfo.steps.count, currentIndex: $currentCardIndex, showPageDots: true, bgView: AnyView(
                    BackgroundBlurView()
                        .background(cardInfo.bgCol)
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                )
            ) {
                ForEach(cardInfo.steps.indices) { step in
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Step \(step + 1)")
                                .font(.headline)
                                .padding(.bottom)

                                
                            
                            Text(cardInfo.steps[step])
                                .lineLimit(4)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                                
                        }
                        
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            .frame(height: 150)

        }
        .padding()
        .background(Color(UIColor.tertiarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
        .padding()
    }
}


struct SetPlaylistInstructionsView: View {
    @Binding var rootIsActive : Bool
    
    @State var cards : [InstructCard] = [
        InstructCard(
            title: "Spotify (Desktop)",
            icon: "Spotify_Icon_RGB_Green",
            bgCol: Color(red: 30/255, green: 215/255, blue: 96/255),
            steps: [
                 "Share your exported cover to your Desktop.",
                 "Open the Spotify app on your Windows PC, Mac, or on the Web.",
                 "Select one of your playlists from the sidebar.",
                 "Hover over the playlist cover and click the pencil (edit) icon.",
                 "Click the three-dot menu icon in the corner of the cover and select Replace Image.",
                 "A file selection window will open. Choose the exported cover you shared to your Desktop.",
                 "Once you see your new cover art, click 'Save' and enjoy!"
            ]
        ),
        
        InstructCard(
            title: "Spotify (Mobile)",
            icon: "Spotify_Icon_RGB_Green",
            bgCol: Color(red: 30/255, green: 215/255, blue: 96/255),
            steps: [
                 "Open the Spotify app.",
                 "Navigate to the playlist you've created.",
                 "Select the three dots that bring up the menu.",
                 "Tap 'edit.'",
                 "Tap 'change image' to choose a new image, then scroll through your photo library to select the right one.",
                 "Change up the title if you’d like, then write in a description underneath and tap 'done!'"
            ]
        ),
        
        InstructCard(
            title: "Apple Music",
            icon: "Apple_Music_Icon",
            bgCol: Color.pink,
            steps: [
                "Open the Music app",
                "Select one of your playlists.",
                "Tap on 'Edit' in the top right corner.",
                "Tap on the cover art.",
                "This will open a menu for editing the playlist details.",
                "Choose the exported cover you want from your Photo Library, then click Choose.",
                "Once you see your new cover art, click 'Done' in the top right. Enjoy!"
    
            ]
        )
    ]
    
    
    
    @State var currentSpotifyIndex : Int = 0
    @State var currentAppleIndex : Int = 0
    
    func dismissSelf() {
        withAnimation {
            rootIsActive = false
        }
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack() {
                /*Text("How to add your Covers to your Playlists.")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .padding(.top)*/
                
                Text("Your selected covers have been exported to your Photo Library.\n\nRead on to learn how to set them as your Playlist covers in Spotify or Apple Music!")
                    .multilineTextAlignment(.leading)
                    .padding()
                
                ForEach(self.cards.indices, id: \.self) { card in
                    InstructCardView(cardInfo: self.$cards[card])
                }
                
                // Got it button
                Button(action: dismissSelf) {
                    Label("All set up", systemImage: "checkmark.circle.fill")
                        .foregroundColor(Color.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous).inset(by: 1))
                        .padding(1)
                        .background(Color(UIColor.tertiarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
                
            }
        }
        .navigationTitle("Export instructions")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(UIDevice.current.userInterfaceIdiom == .phone)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                // Dismiss button
                if (UIDevice.current.userInterfaceIdiom == .phone) {
                    PillButton(label: "Done") {
                        dismissSelf()
                    }
                } else {
                    EmptyView()
                }
            }
        }
        
    }
}
