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
open FSPlayerExample.xcworkspace
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

This is the default option intended for normal framework consumption.

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
