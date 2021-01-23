# Cover Buddy

**Cover Buddy** is an iOS app for designing beautiful custom playlist covers.

Simply choose a background from the wide variety of presets, then customize the text font, size, colors, and positioning to truly make it yours. 

Save your custom designs to your cover library, then export them to your photo library and get help setting them as your playlist cover in Spotify, Apple Music, Deezer, and more. 

If you want to see pretty pictures and learn about how it was made, read on. If you just want to play with the code, hop right in 😊. 

Cover Buddy is built mostly to mess around with SwiftUI, but the app has an MVP feature set.

-   Select from a vast library of backgrounds
-   Save Covers to your Library and sync between devices via iCloud
-   Export covers and get help adding them to Playlists on Spotify, Apple Music, Deezer, and more
-   Use custom fonts you've installed to your device
-   Customize the font, size, position, and colors of your text
-   Gorgeous native interface
-   Scales to iPad and supports all split-screen combinations
-   Native dark mode support

## Screenshots

Library View         |  Collections View | Preset Carousel View | Editing View
:-------------------------:|:-------------------------:|:-------------------------:|:------------------------:
![Library View](https://tarrouye.net/ios/coverbuddy/assets/library_view.png)  |  ![Collections View](https://tarrouye.net/ios/coverbuddy/assets/collections_view.png) | ![Preset Selection](https://tarrouye.net/ios/coverbuddy/assets/preset_selection.png) | ![Editing View](https://tarrouye.net/ios/coverbuddy/assets/editing_view.png)




iPad Library View |  iPad Collections View | iPad Preset Carousel View 
:-------------------------:|:-------------------------:|:-------------------------:
![iPad Library View](https://tarrouye.net/ios/coverbuddy/assets/ipad_library_dark.png)  |  ![iPad Collections View](https://tarrouye.net/ios/coverbuddy/assets/ipad_collections_dark.png) | ![iPad Preset Selection](https://tarrouye.net/ios/coverbuddy/assets/ipad_preset_dark.png)

Split Screen Support |  Slide Over Support 
:-------------------------:|:-------------------------:
![Split Screen](https://tarrouye.net/ios/coverbuddy/assets/ipad_split_screen.png)  |  ![Slide Over](https://tarrouye.net/ios/coverbuddy/assets/ipad_slide_over.png)  


## Tech stack

Cover Buddy is built with Swift 5 and SwiftUI 2.0

It makes use of Core Data and CloudKit for data storage and syncing. 

## Dependencies

There are no dependencies required to make it work.

It does, however, come including [the amazing UIImageColors utility](https://github.com/jathu/UIImageColors) which is used for fetching colors from the backgrounds. Shout out to them for that awesome piece of kit. 

## Fun/useful parts
 - `BackgroundBlurView`, a SwiftUI `View` to be used in .background() modifier or under views to provide the native frosted glass effect. Simply wraps a `UIVisualEffectView` with `UIBlurEffect` thin style.
- `SpicyStack`, a SwiftUI `View` that takes another `View` in as content and places it in either an HStack or a VStack depending on the window size. Useful for building layouts that adapt between iOS and iPadOS. 

## Feedback
If you have any feedback about the code or want to contribute, please open a Pull Request, an Issue, or shoot me an e-mail. This is only my second SwiftUI application and I'm always open to constructive criticism. 

## License
You may take any of the code found within this repository and do whatever you wish with it. Take the app as is and sell it on the App Store, for all I care 😊 

When the opportunity presents itself, please give back to the community! 