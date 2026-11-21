# ClockStudio for Mac — starter build

ClockStudio is a SwiftUI macOS clock designer. This starter project includes:

- Live clock preview
- Font family and weight selection
- Colour picker and colour swatches
- Clock size and letter spacing
- Date, seconds and 12/24-hour toggles
- Four editable starting presets
- Full-screen clock presentation with three background ambiences
- Settings saved between launches using `AppStorage`

## Important Lock Screen limitation

macOS does not provide a public API for third-party apps to replace or freely restyle the secure native Lock Screen clock. This project deliberately does not use private APIs, inject code into system processes, or simulate the password screen.

The Lock Screen tab explains this and offers a shortcut to System Settings. If the installed macOS release exposes native clock appearance settings, those must be changed through Apple's own settings. ClockStudio's custom typography and colours apply to ClockStudio's full-screen clock.

## Build

Requirements: a Mac running macOS 13 or later and Xcode 15 or later.

1. Unzip the project.
2. Open Terminal in the `ClockStudio` folder.
3. Run:

   ```sh
   swift build
   swift run
   ```

For a distributable `.app`, open the folder in Xcode as a Swift Package, select the ClockStudio scheme, then use Product → Archive and export/sign it for your Mac.

## About screensaver behavior

This starter provides a full-screen clock mode that can be opened on demand. It is not yet an installable `.saver` module that macOS launches automatically after an idle timeout. That requires a separate ScreenSaver extension target and testing/signing against the exact macOS SDK. The SwiftUI clock renderer and saved preferences are structured so they can be reused in that target.
