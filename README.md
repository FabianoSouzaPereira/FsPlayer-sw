# FSPlayer

**FSPlayer** is a modular video playback framework for iOS, built with Swift and SwiftUI.

The public type is `Player` (the module is `FSPlayer`). CocoaPods manages dependencies. XcodeGen generates the example app project.

---

## Requirements

- iOS 16.2+
- Swift 5.10
- Xcode 14.2+ (Lottie's vendored xcframework is the official Xcode 14.1 build)
- CocoaPods
- XcodeGen

---

## Usage

```swift
import FSPlayer
import SwiftUI

struct ContentView: View {
    @StateObject private var player = Player(
        item: PlayerItem(
            url: URL(string: "https://example.com/video.m3u8")!,
            title: "Demo",
            artworkURL: URL(string: "https://example.com/poster.jpg")
        )
    )

    var body: some View {
        PlayerView(player: player)
            .ignoresSafeArea()
            .onAppear { player.play() }
            .onDisappear { player.pause() }
    }
}
```

`PlayerItem.artworkURL` is optional. When present, Kingfisher loads the poster. Lottie renders the buffering animation.

If another type named `Player` is in scope, qualify it as `FSPlayer.Player`.

Local videos live in the Photos library; songs live in the Music / media library. That lookup is `DeviceMediaLibrary`, not `Player`. Resolve an item, then load it:

```swift
let library = DeviceMediaLibrary()
let videos = try await library.videos(matching: "holiday")
if let item = videos.first {
    let playerItem = try await library.playerItem(for: item)
    player.load(playerItem)
    player.play()
}
```

The title on the player is a button that opens the in-player **Queue**. **Now Playing** publishes lock-screen / Control Center metadata and remote commands (play, pause, next, previous, scrub).

```swift
player.loadQueue([item1, item2])
player.play()
player.playNext()
player.activateNowPlaying()
```

The host app should include `UIBackgroundModes` → `audio` so Now Playing survives the lock screen.

---

## Status and next steps

FSPlayer **0.1.0** is a playback kernel, not a finished streaming player. You can embed `Player` + `PlayerView`, play a URL or a queue, use lock-screen controls, and resolve local Photos/Music items. Treat everything below as still missing if you are shipping a product on top of this pod.

### Already in the kernel

- Session API: load, play, pause, seek, stop, mute, volume, queue (`loadQueue`, `playNext`, `playPrevious`)
- SwiftUI chrome: video layer, timeline, poster (Kingfisher), buffering (Lottie), in-player queue panel
- Now Playing / Control Center remote commands
- `DeviceMediaLibrary` for device videos and songs → `PlayerItem`
- CocoaPods Binary (xcframework) and Debug (source) subspecs

### Next steps in this repository (`Sources/FSPlayer`)

1. **Picture in Picture** — `AVPictureInPictureController` on the existing `PlayerVideoOutput` / `AVPlayerLayer` surface
2. **Subtitles / captions** — sidecar SRT/VTT and `AVMediaSelection` audio/caption tracks on `PlayerItem`
3. **Playback rate** — 0.5× / 1.5× / 2× on the engine, reflected in Now Playing `playbackRate`
4. **Mute and volume in the chrome** — `isMuted` / `volume` exist on `Player` but are not on `PlayerControlsView`
5. **Now Playing artwork** — load `PlayerItem.artworkURL` into `MPMediaItemArtwork`
6. **AirPlay picker** — `allowsExternalPlayback` is in `PlayerConfiguration`; there is no route-picker UI
7. **Resume position** — persist `currentTime` per item so a later `load` can seek
8. **Offline / download** — HLS `AVAssetDownloadTask` producing a local URL for `PlayerItem`
9. **Controls auto-hide** — replace `asyncAfter` with a cancellable hide so pause/tap cannot fire a stale hide
10. **Publish the pod** — CocoaPods trunk, or a tagged git install that does not require copying `Vendor/LottieXCFramework.podspec`

### What belongs in the consuming app (not this repo)

- Screens that list `DeviceMediaLibrary` results, catalog, search UI, login, VIPER modules
- Analytics, recommendations, continue-watching via backend, paywall, Chromecast product UI
- `NSPhotoLibraryUsageDescription`, `NSAppleMusicUsageDescription`, and `UIBackgroundModes` → `audio` in **your** Info.plist

The example app stays a dumb host. Do not add those product features to `FSPlayerExample`.

---

## Architecture

`Player` is the public session (`ObservableObject`). Apps hold that type and pass it to `PlayerView`. Playback talks to an internal `PlayerEngine`; the default implementation is `AVFoundationPlayerEngine`. `AVPlayer` stays inside that engine. The SwiftUI layer binds video with `attachVideo(to:)`, not by reading the player object.

Mute, volume, and the audio session go through the engine protocol. Tests inject `FakePlayerEngine` (`@testable`) so load / play / pause / seek / mute do not need a real `AVPlayer`.

`DeviceMediaLibrary` sits next to `Player` under `Sources/FSPlayer/DeviceMedia`. It lists device videos (Photos) and songs (MediaPlayer) and turns a `DeviceMediaItem` into a `PlayerItem`. It does not play, navigate, or own UI.

`PlaybackQueue` (`Sources/FSPlayer/Queue`) is the play-next / play-previous list the `Player` owns. `NowPlayingSession` (`Sources/FSPlayer/NowPlaying`) mirrors the session to `MPNowPlayingInfoCenter` and `MPRemoteCommandCenter`. The example stays a dumb host; product chrome around the queue belongs in the consuming app.

Login, session, other services, and VIPER modules belong in the **consuming app**, not here.

---



## Project Structure

```text
FSPlayer/
├── Sources/FSPlayer/
│   ├── Player.swift           # Public session
│   ├── Queue/                 # PlaybackQueue
│   ├── NowPlaying/            # Lock screen / remote commands
│   ├── Engine/                # PlayerEngine + AVFoundation implementation
│   ├── DeviceMedia/           # Photos videos + Music library → PlayerItem
│   ├── UI/                    # PlayerView, controls, poster, buffering, queue panel
│   ├── Models/
│   ├── Core/
│   └── Resources/             # buffering.json, etc.
├── Tests/
│   ├── FSPlayerTests/         # Includes FakePlayerEngine
│   └── FSPlayerUITests/
├── FSPlayerExample/           # Dumb host: run the module and tests only
│   ├── project.yml            # XcodeGen spec (`postGenCommand: pod install`)
│   ├── Podfile
│   └── FSPlayerExample/
├── Vendor/
│   └── LottieXCFramework.podspec
├── FSPlayer.xcframework/      # Prebuilt Binary distribution (`make generate`)
├── FsPlayer.podspec
├── LICENSE
├── README.md
└── Makefile
```

`Pods/` is gitignored. After a clone, run `make generate` (or `make project`) before opening Xcode.

---



## Installation

FSPlayer is not on CocoaPods trunk yet. Point CocoaPods at this repository (or a local checkout) and at the Lottie wrapper spec. `LottieXCFramework` is **not** on trunk; `pod 'FSPlayer'` alone will not resolve it.

### Binary (apps that consume FSPlayer)

Default when `FSPlayer.xcframework` is present in the pod. Use this in production apps.

```ruby
pod 'FSPlayer', :git => 'https://github.com/FabianoSouzaPereira/FsPlayer-sw.git', :tag => '0.1.0'
pod 'LottieXCFramework', :podspec => 'Vendor/LottieXCFramework.podspec'
```

Copy `Vendor/LottieXCFramework.podspec` into the consuming app (or point `:podspec` at a checkout of this repo). Then:

```bash
pod install
open YourProject.xcworkspace
```

Until the xcframework exists in the pod, `pod 'FSPlayer'` falls back to the Debug subspec.

### Debug (compile FSPlayer from source)

```ruby
pod 'FSPlayer/Debug', :git => 'https://github.com/FabianoSouzaPereira/FsPlayer-sw.git', :tag => '0.1.0'
pod 'LottieXCFramework', :podspec => 'Vendor/LottieXCFramework.podspec'
```

Use Debug to develop FSPlayer, step through its implementation, or try source changes. Do not switch the example app to Binary as a “production” step.

> `Binary` and `Debug` are CocoaPods subspecs. They are not Xcode’s Debug and Release configurations.

---



## Local Development

`FSPlayerExample` is a dumb host: it instantiates `Player`, shows `PlayerView`, and runs the test targets. It must not grow product features (login, networking, VIPER screens). Those live in the app that consumes the pod.

The example Podfile compiles local sources on purpose:

```ruby
pod 'FSPlayer/Debug', :path => '../'
pod 'LottieXCFramework', :podspec => '../Vendor/LottieXCFramework.podspec'
```

`:path` means this checkout, not a production install. Keep `/Debug` here so edits under `Sources/FSPlayer` show up on the next build. `pod 'FSPlayer', :path => '../'` would link the root xcframework instead, and source changes would not appear until `make generate` rebuilds it.

From the repository root:

```bash
make generate
open FSPlayerExample/FSPlayerExample.xcworkspace
```


| Command         | What it does                                                                                               |
| --------------- | ---------------------------------------------------------------------------------------------------------- |
| `make generate` | XcodeGen + `pod install`, then builds `FSPlayer.xcframework` at the repo root                              |
| `make project`  | XcodeGen + `pod install` only (enough to run the example)                                                  |
| `make clean`    | Deletes `FSPlayerExample/Pods`, `Podfile.lock`, the generated `.xcodeproj` / `.xcworkspace`, and `.build/` |


`make generate` is what you run after a fresh clone. Use `make project` when you only need the example and do not want to re-archive the xcframework.

XcodeGen reads `FSPlayerExample/project.yml`. It generates the example app and test targets only. It does not generate the FSPlayer module; CocoaPods compiles `Sources/FSPlayer` through the Debug subspec (or the Makefile archives that pod target into the xcframework).

Typical loop:

```text
Edit Sources/FSPlayer
        │
        ▼
Build and run FSPlayerExample
        │
        ▼
Run tests
```

Re-run `make project` after Podfile or `project.yml` changes. Re-run `make generate` when you need a fresh `FSPlayer.xcframework`.

---



## CocoaPods

`FsPlayer.podspec` defines the pod: name, version `0.1.0`, iOS 16.2, Swift 5.10, Apple frameworks, git source, Binary vs Debug, and third-party dependencies.

```ruby
spec.dependency 'Kingfisher', '>= 8.0', '< 8.5'
spec.dependency 'LottieXCFramework', '4.4.3'
```

Both sit on the root spec, so Binary and Debug inherit them.

### Kingfisher (source)

Compiled from CocoaPods trunk. It is **not** listed in the example Podfile. CocoaPods puts the Swift sources in `FSPlayerExample/Pods/Kingfisher`.

Pinned below 8.5 because 8.5+ uses the iOS 17 `Transition` protocol and does not compile against the iOS 16.2 SDK.

### Lottie (binary xcframework)

Consumed as a prebuilt xcframework, not as `pod 'lottie-ios'` (that pod compiles from source and conflicts with the binary).

The wrapper downloads Lottie 4.4.3’s official `Lottie-Xcode-14.1.xcframework.zip` (`module_name` is `Lottie`). Later official xcframeworks are built with a newer Swift and will not import in this SDK.

After `pod install`, on disk:

- `FSPlayerExample/Pods/Kingfisher` — source
- `FSPlayerExample/Pods/LottieXCFramework` — `Lottie.xcframework`

---



## License

FSPlayer is available under the MIT License.

See the [LICENSE](LICENSE) file for more information.

---



## Author

**Fabiano Pereira**

GitHub: [https://github.com/FabianoSouzaPereira](https://github.com/FabianoSouzaPereira)

Youtube channel: [https://www.youtube.com/@exploringthemobileworld7931](https://www.youtube.com/@exploringthemobileworld7931) 