Vamos ver todos os arquivos agora, antes de mexer neles.

#Podefile
# Uncomment the next line to define a global platform for your project
platform :ios, '16.2'
project 'FsPlayerExample.xcodeproj'

use_frameworks!

target 'FsPlayerExample' do
  pod 'FsPlayer', :path => '../'
end

target 'FsPlayerTests' do
  inherit! :search_paths
end

target 'FsPlayerUITests' do
  inherit! :search_paths
end

#FsPlayer.podspec
Pod::Spec.new do |spec|

  spec.name         = "FsPlayer"
  spec.version      = "0.1.0"
  spec.summary      = "Modern video player framework for iOS."

  spec.description  = <<-DESC
FsPlayer is a modular and modern video playback framework
built with Swift and SwiftUI.
  DESC

  spec.homepage     = "https://github.com/FabianoSouzaPereira/FsPlayer-sw"
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author       = { "Fabiano Pereira" => "jeovajire2003@gmail.com" }

  spec.platform     = :ios, "16.2"

  spec.source       = {
    :git => "https://github.com/FabianoSouzaPereira/FsPlayer-sw.git",
    :tag => spec.version.to_s
  }

  spec.swift_version = "5.10"

  spec.source_files = "Sources/FsPlayer/**/*.{swift}"

  spec.frameworks = "AVFoundation", "UIKit"

  spec.pod_target_xcconfig = {
    'ENABLE_BITCODE' => 'NO',
    'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES',
    'SWIFT_VERSION' => '5.10',
    'IPHONEOS_DEPLOYMENT_TARGET' => '16.2',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }

  spec.default_subspec = "Debug"

  spec.subspec "Release" do |release|
    release.vendored_frameworks = "FsPlayer.xcframework"

    release.resources = 'Sources/FsPlayer/Resources/**/*.{plist,xib,json,ttf,xcassets,strings,xcassets}'

    release.dependencies = {}
  end

  spec.subspec "Debug" do |debug|
    debug.vendored_frameworks = "FsPlayer.xcframework"

    debug.resources = 'Sources/FsPlayer/Resources/**/*.{swift,plist,xib,json,ttf,xcassets,strings,xcassets}'

    debug.dependencies = {}

    #debug.test_spec "Tests" do |test|
    # test_spec.source_files = "Tests/**/*.{swift}"
    # test.resources = 'Tests/Resources/**/*.{plist,xib,json,ttf,xcassets,strings,xcassets}'
    # test.frameworks = "XCTest"
    # test.dependencies = {
    # "FsPlayer/Debug" => []
    #}
    #end
  end
end

# Project.yml
name: FsPlayerExample

options:
  createIntermediateGroups: false
  groupSortPosition: top

  postGenCommand: | 
    echo "Podfile.lock ... REMOVED"
    rm -f Podfile.lock
    echo Pods ... REMOVED
    rm -rf Pods
    echo "Installing pods..."
    pod install --verbose

  bundleIdPrefix: com.fabianospdev
  deploymentTarget:
    iOS: 16.2

settings:
  base:
    ALWAYS_SEARCH_USER_PATHS: YES
    BUILD_LIBRARY_FOR_DISTRIBUTION: YES
    SWIFT_VERSION: 5.10

  DEBUG:
    ENABLE_TESTABILITY: YES
    ONLY_ACTIVE_ARCH: YES
    SWIFT_OPTIMIZATION_LEVEL: "-Onone"

targets:
  FsPlayerExample:
    type: application
    platform: iOS
    sources:
      -  path: ./FsPlayerExample
    info:
      path: ./FsPlayerExample/Info.plist
    settings:
      base:
        PRODUCT_BUNDLE_IDENTIFIER: com.fabianospdev.fsplayerexample
        PRODUCT_NAME: $(TARGET_NAME)
        DEVELOPMENT_TEAM: 9Z2K5Z7V3C
        INFOPLIST_FILE: FsPlayerExample/Info.plist
        TARGETED_DEVICE_FAMILY: 1

  FsPlayerTests:
    type: bundle.unit-test
    platform: iOS
    dependencies:
      - target: FsPlayerExample
    sources:
      - ../Tests/FsPlayerTests
    info:
      path: ../Tests/FsPlayerTests/Info.plist
      group: Tests

  FsPlayerUITests:
    type: bundle.ui-testing
    platform: iOS
    sources:
      - ../Tests/FsPlayerUITests

    info:
      path: ../Tests/FsPlayerUITests/Info.plist
      group: Tests

    dependencies:
      - target: FsPlayerExample

schemes:
  FsPlayerExample:
    build:
      targets:
        FsPlayerExample: all
    buildImplicitDependencies: true
    test:
      gatherCoverageData: true
      coverageTargets:
        - FsPlayerExample
      targets:
        - name: FsPlayerTests
        - name: FsPlayerUITests 
          parallelizable: true 

# Podfile.lock
PODS:
  - FsPlayer (0.1.0):
    - FsPlayer/Debug (= 0.1.0)
  - FsPlayer/Debug (0.1.0)

DEPENDENCIES:
  - FsPlayer (from `../`)

EXTERNAL SOURCES:
  FsPlayer:
    :path: "../"

SPEC CHECKSUMS:
  FsPlayer: 2774097808ccb90cc5f60fe8225450ef02b4995a

PODFILE CHECKSUM: b05825399c57a8e33977afc1798f4d06892ee9d1

COCOAPODS: 1.16.2
