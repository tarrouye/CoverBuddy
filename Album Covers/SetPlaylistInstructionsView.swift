//
//  SetPlaylistInstructionsView.swift
//  Cover Buddy
//
//  Created by Théo Arrouye on 1/18/21.
//

import SwiftUI

struct SetPlaylistInstructionsView: View {
    @Binding var rootIsActive : Bool
    
    @ObservedObject var imageSaver : ImageSaver = ImageSaver.shared
    
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
                "Open the Music app.",
                "Select one of your playlists.",
                "Tap on the three-dot menu in the top right corner, then select 'Edit'.",
                "Tap on the cover art.",
                "Choose the exported cover you want from your Photo Library, then click Choose.",
                "Once you see your new cover art, click 'Done' in the top right. Enjoy!"
    
            ]
        ),
        
        InstructCard(
            title: "Deezer",
            icon: "Deezer_Logo_Circle",
            bgCol: Color.orange,
            steps: [
                "Open the Deezer app.",
                "Select one of your playlists.",
                "Tap the pencil (edit) button.",
                "Tap on the cover art.",
                "Choose the exported cover you want from your Photo Library, then click Choose.",
                "Once you see your new cover art, click 'Done' in the top right. Enjoy!"
    
            ]
        ),
        
        InstructCard(
            title: "Tidal",
            icon: "Tidal_Logo",
            bgCol: Color.gray
        ),
        
        InstructCard(
            title: "Amazon Music",
            icon: "Amazon_Music_Logo",
            bgCol: Color.blue
        ),
        
        InstructCard(
            title: "YouTube Music",
            icon: "Youtube_Music_Logo",
            bgCol: Color.red
        ),
        
        InstructCard(
            title: "Pandora",
            icon: "Pandora_Logo",
            bgCol: Color.purple
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
        ScrollView(imageSaver.latestSaveSuceeded ? .vertical : []) {
            VStack() {
                if imageSaver.latestSaveSuceeded {
                    Text("Your selected covers have been exported to your Photo Library.\n\nRead on to learn how to set them as your Playlist covers in Spotify, Apple Music, or another streaming service!")
                        .multilineTextAlignment(.leading)
                        .padding()
                    
                    ForEach(self.cards.indices, id: \.self) { card in
                        InstructCardView(cardInfo: self.$cards[card], rootIsActive: self.$rootIsActive)
                    }
                } else {
                    Text("Image Save Failure")
                        .font(.title2)
                        .padding()
                        .padding(.top)
                    
                    Text("Your custom cover failed the export to the Photo Library.\n\nPlease check in Settings that you have granted the app appropriate permissions.\n\nIf the issue persists, please contact Support or file Feedback.")
                        .multilineTextAlignment(.leading)
                        .padding()
                }
                
                // Got it button
                RimmedRectButton(label: imageSaver.latestSaveSuceeded ? "All set up" : "Understood", systemImage: "checkmark.circle.fill") {
                    self.dismissSelf()
                }
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
