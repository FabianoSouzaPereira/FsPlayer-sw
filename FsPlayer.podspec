# FsPlayer.podspec
Pod::Spec.new do |spec|
  spec.name             = 'FsPlayer'
  spec.version          = '0.1.0'
  spec.summary          = 'Modern video player framework for iOs.'
  spec.description      = <<-DESC
                       FsPlayer is a modular and modern video player framework built with Swift and SwiftUI. 
                       It provides a simple API for playback control.
                       DESC
  spec.homepage         = "https://github.com/FabianoSouzaPereira/FsPlayer-sw"  
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { 'Fabiano Souza Pereira' => 'jeovajire2003@gmail.com' } 
  spec.platform         = :ios, '16.2'
  spec.source           = { :git => "https://github.com/FabianoSouzaPereira/FsPlayer-sw.git", :tag => "spec.version" }
  spec.swift_version    = '5.10'
  spec.frameworks       = ['Foundation', 'UIKit', 'AVFoundation', 'SwiftUI', 'Combine']

  spec.default_subspec = 'Binary'

  # ----------------------------------------
  # Binary distributon
  # ----------------------------------------

  spec.subspec 'Binary' do |binary|
    binary.vendored_frameworks = 'FsPlayer.xcframework'
    binary.resources = "Sources/FSPlayer/Resources/**/*.{plist,xib,json,ttf,xcassets,strings}"
  end
 
  # ----------------------------------------
  # Debug distributon
  # ----------------------------------------

  spec.subspec "Debug" do |debug|
    debug.source_files =  "Sources/FsPlayer/**/*.swift"
    debug.resources =  "Sources/FsPlayer/Resources/**/*.{plist,xib,json,ttf,xcassets,strings}"

  end

end
