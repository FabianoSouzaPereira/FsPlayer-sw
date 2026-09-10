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