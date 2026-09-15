# FSPlayer

**FSPlayer** is a modern and modular video playback framework for iOS, built with Swift and designed to provide a flexible foundation for video playback features.

The project uses **CocoaPods** for dependency management and **XcodeGen** to generate the Xcode project for the example application.

---

## Requirements

* iOS 16.2+
* Swift 5.10+
* Xcode
* CocoaPods
* XcodeGen

---

## Project Structure

```text
FSPlayer/
│
├── Sources/
│   └── FSPlayer/
│       ├── ...
│       └── Resources/
│
├── Tests/
│   ├── FSPlayerTests/
│   └── FSPlayerUITests/
│
├── Example/
│   ├── project.yml
│   ├── Podfile
│   └── FSPlayerExample/
│
├── Vendor/
│   └── LottieXCFramework.podspec
├── FSPlayer.xcframework/
├── FSPlayer.podspec
├── LICENSE
├── README.md
└── Makefile
```

### Sources

The `Sources` directory contains the source code for the FSPlayer framework.

### Tests

The `Tests` directory contains the unit tests and UI tests for the project.

### Example

The `Example` directory contains the sample application used to develop, test, and validate FSPlayer.

It also contains:

* `project.yml` — XcodeGen project specification
* `Podfile` — CocoaPods configuration
* `FSPlayerExample` — Example application source code

---

# Installation

FSPlayer supports two different ways of being consumed through CocoaPods.

## Binary Distribution

By default, FSPlayer is distributed as a prebuilt XCFramework.

Add the following to your `Podfile`:

```ruby
pod 'FSPlayer'
```

Then run:

```bash
pod install
```

Open the generated workspace:

```bash
open YourProject.xcworkspace
```

---

## Development Version

For development and debugging, you can use the source-based version of FSPlayer.

Add the `Debug` subspec:

```ruby
pod 'FSPlayer/Debug'
```

This version uses the framework's Swift source files directly.

This is useful when you need to:

* Develop FSPlayer
* Debug the framework implementation
* Inspect the source code
* Test changes directly in the example application

---

# Local Development

The repository includes an example application that uses FSPlayer through a local CocoaPods dependency.

The `Podfile` inside the `Example` directory uses:

```ruby
pod 'FSPlayer', :path => '../'
```

This allows the example application to use the local version of the framework while it is being developed.

---

# Generating the Xcode Project

From the repository root, run:

```bash
make generate
```

That single command generates the example project, installs CocoaPods dependencies, and builds `FSPlayer.xcframework`.

The XcodeGen specification is:

```text
FSPlayerExample/project.yml
```

Open the generated workspace:

```bash
open FSPlayerExample/FSPlayerExample.xcworkspace
```

---

# Using the Makefile

The project can also provide commands that allow you to work from the repository root.

For example:

```bash
make generate
```

This is the only command needed to prepare the project. It:

* Generates the example Xcode project with XcodeGen
* Installs CocoaPods dependencies (Kingfisher from source, Lottie xcframework into `Pods/`)
* Builds `FSPlayer.xcframework` at the repository root

After it finishes, open `FSPlayerExample/FSPlayerExample.xcworkspace`. When the xcframework exists, `pod 'FSPlayer'` defaults to the Binary subspec. The example app still uses `pod 'FSPlayer/Debug'` so you keep compiling the player from source.

```bash
make clean
```

Removes generated files and CocoaPods dependencies.

---

# XcodeGen

FSPlayer uses XcodeGen to generate the Xcode project for the example application.

The `project.yml` file defines:

* The example application target
* Unit test targets
* UI test targets
* Build settings
* Schemes
* Code coverage configuration

XcodeGen is used only to generate the Xcode project for the example application and its test targets.

It does not directly generate the FSPlayer framework.

---

# CocoaPods

CocoaPods is responsible for integrating FSPlayer into the example application and into projects that consume the framework.

The framework configuration is defined in:

```text
FSPlayer.podspec
```

The Podspec contains information such as:

* Framework name
* Version
* Supported iOS version
* Swift version
* Required Apple frameworks
* Source repository
* License
* Binary framework configuration
* Source-based development configuration
* Third-party source dependency (Kingfisher)
* Third-party binary dependency (LottieXCFramework)

---

# Third-party Frameworks

FSPlayer demonstrates two CocoaPods inclusion patterns. Both are declared on the root of `FSPlayer.podspec`, so the `Binary` and `Debug` subspecs inherit them.

```ruby
spec.dependency 'Kingfisher', '>= 8.0', '< 8.5'
spec.dependency 'LottieXCFramework', '4.4.3'
```

## Source dependency

Kingfisher is compiled from source. It lives on CocoaPods trunk, so it is **not** listed in the example `Podfile`. CocoaPods downloads the Swift sources into `Pods/Kingfisher`.

The player uses Kingfisher to load the optional `PlayerItem.artworkURL` poster image.

Kingfisher is pinned below 8.5 because 8.5+ uses the iOS 17 `Transition` protocol and does not compile against the iOS 16.2 SDK.

## Binary dependency

Lottie is consumed as a prebuilt xcframework, not as `pod 'lottie-ios'` (that pod would compile from source and conflict with the binary).

Because the xcframework is not on trunk, the example `Podfile` points CocoaPods at the local wrapper spec. CocoaPods then downloads the zip into `Pods/`:

```ruby
pod 'FSPlayer/Debug', :path => '../'
pod 'LottieXCFramework', :podspec => '../Vendor/LottieXCFramework.podspec'
```

The player uses Lottie to render the buffering animation.

The wrapper downloads Lottie 4.4.3's official `Lottie-Xcode-14.1.xcframework.zip`, which matches this project's Xcode 14 / iOS 16 SDK. Later Lottie xcframeworks are built with a newer Swift and will not import.

After `pod install`, the navigator should show:

* `Pods/Pods/Kingfisher` — source
* `Pods/Pods/LottieXCFramework` — `Lottie.xcframework`

---

# Binary and Debug Subspecs

FSPlayer supports two different consumption strategies.

## Default Binary Version

```ruby
pod 'FSPlayer'
```

This installs the prebuilt:

```text
FSPlayer.xcframework
```

This is the default option when that xcframework is present. `make generate` builds it. Until then, `pod 'FSPlayer'` falls back to Debug.

---

## Debug Version

```ruby
pod 'FSPlayer/Debug'
```

This version uses the FSPlayer source code directly.

```text
Sources/FSPlayer/
```

This is intended for framework development and debugging.

> The `Binary` and `Debug` subspecs should not be confused with Xcode's Debug and Release build configurations.

They represent different ways of consuming the FSPlayer framework through CocoaPods.

---

# Development Workflow

The typical development workflow looks like this:

```text
Developer
    │
    ▼
Modify FSPlayer source code
    │
    ▼
Generate the Example project with XcodeGen
    │
    ▼
Install dependencies with CocoaPods
    │
    ▼
Build and run FSPlayerExample
    │
    ▼
Run tests
```

The example application allows the framework to be tested in a real application environment while it is being developed.

---

# License

FSPlayer is available under the MIT License.

See the [LICENSE](LICENSE) file for more information.

---

# Author

**Fabiano Pereira**

GitHub: https://github.com/FabianoSouzaPereira
