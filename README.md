# FsPlayer

**FsPlayer** is a modern and modular video playback framework for iOS, built with Swift and designed to provide a flexible foundation for video playback features.

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
FsPlayer/
│
├── Sources/
│   └── FsPlayer/
│       ├── ...
│       └── Resources/
│
├── Tests/
│   ├── FsPlayerTests/
│   └── FsPlayerUITests/
│
├── Example/
│   ├── project.yml
│   ├── Podfile
│   └── FsPlayerExample/
│
├── FsPlayer.xcframework/
├── FsPlayer.podspec
├── LICENSE
├── README.md
└── Makefile
```

### Sources

The `Sources` directory contains the source code for the FsPlayer framework.

### Tests

The `Tests` directory contains the unit tests and UI tests for the project.

### Example

The `Example` directory contains the sample application used to develop, test, and validate FsPlayer.

It also contains:

* `project.yml` — XcodeGen project specification
* `Podfile` — CocoaPods configuration
* `FsPlayerExample` — Example application source code

---

# Installation

FsPlayer supports two different ways of being consumed through CocoaPods.

## Binary Distribution

By default, FsPlayer is distributed as a prebuilt XCFramework.

Add the following to your `Podfile`:

```ruby
pod 'FsPlayer'
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

For development and debugging, you can use the source-based version of FsPlayer.

Add the `Debug` subspec:

```ruby
pod 'FsPlayer/Debug'
```

This version uses the framework's Swift source files directly.

This is useful when you need to:

* Develop FsPlayer
* Debug the framework implementation
* Inspect the source code
* Test changes directly in the example application

---

# Local Development

The repository includes an example application that uses FsPlayer through a local CocoaPods dependency.

The `Podfile` inside the `Example` directory uses:

```ruby
pod 'FsPlayer', :path => '../'
```

This allows the example application to use the local version of the framework while it is being developed.

---

# Generating the Xcode Project

The Xcode project for the example application is generated using XcodeGen.

The project specification is located at:

```text
Example/project.yml
```

You can generate the project manually by running:

```bash
cd Example
xcodegen generate
```

After the project is generated, CocoaPods installs the project dependencies.

The generated workspace can then be opened with:

```bash
open FsPlayerExample.xcworkspace
```

---

# Using the Makefile

The project can also provide commands that allow you to work from the repository root.

For example:

```bash
make generate
```

Generates the Xcode project.

```bash
make install
```

Installs the CocoaPods dependencies.

```bash
make setup
```

Generates the project and prepares the development environment.

```bash
make clean
```

Removes generated files and CocoaPods dependencies.

---

# XcodeGen

FsPlayer uses XcodeGen to generate the Xcode project for the example application.

The `project.yml` file defines:

* The example application target
* Unit test targets
* UI test targets
* Build settings
* Schemes
* Code coverage configuration

XcodeGen is used only to generate the Xcode project for the example application and its test targets.

It does not directly generate the FsPlayer framework.

---

# CocoaPods

CocoaPods is responsible for integrating FsPlayer into the example application and into projects that consume the framework.

The framework configuration is defined in:

```text
FsPlayer.podspec
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

---

# Binary and Debug Subspecs

FsPlayer supports two different consumption strategies.

## Default Binary Version

```ruby
pod 'FsPlayer'
```

This installs the prebuilt:

```text
FsPlayer.xcframework
```

This is the default option intended for normal framework consumption.

---

## Debug Version

```ruby
pod 'FsPlayer/Debug'
```

This version uses the FsPlayer source code directly.

```text
Sources/FsPlayer/
```

This is intended for framework development and debugging.

> The `Binary` and `Debug` subspecs should not be confused with Xcode's Debug and Release build configurations.

They represent different ways of consuming the FsPlayer framework through CocoaPods.

---

# Development Workflow

The typical development workflow looks like this:

```text
Developer
    │
    ▼
Modify FsPlayer source code
    │
    ▼
Generate the Example project with XcodeGen
    │
    ▼
Install dependencies with CocoaPods
    │
    ▼
Build and run FsPlayerExample
    │
    ▼
Run tests
```

The example application allows the framework to be tested in a real application environment while it is being developed.

---

# License

FsPlayer is available under the MIT License.

See the [LICENSE](LICENSE) file for more information.

---

# Author

**Fabiano Pereira**

GitHub: https://github.com/FabianoSouzaPereira
