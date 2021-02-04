# historyprobe
Utility made to dump multiple browser's history across all users to CSV on MacOS. It will include the history from all browser profiles discovered. Current browsers implemented are Brave, Chrome, Microsoft Edge (Dev), Firefox, Opera, Safari, and Vivaldi. historyprobe must be run as root in order to enumerate across all user home directories.

Note: In order dump Safari history on Mojave+ historyprobe must be granted Full Disk Access under System Preferences -> Security & Privacy -> Privacy -> Full Disk Access.

To build from source run the following command in a terminal from the project root directory:
```bash
swift build -Xswiftc "-import-objc-header" -Xswiftc "Sources/historyprobe/historyprobe-Bridging-Header.h" --static-swift-stdlib -c release
```

To create an Xcode project run the following command from a terminal in the project root directory:
```bash
swift package generate-xcodeproj
```
Open up the Xcode project created and then go to historyprobe Project Setttings -> Build Settings -> Swift Compiler - General -> Objective-C Bridging Header enter the following value **Sources/historyprobe/historyprobe-Bridging-Header.h**. Hit the play button to build and run the project.

Before running please move the **browsers.json** file into the same path as the executable. Swift CLI applications are not created with a Bundle so there's no good way to include it with the executable that I've found.
