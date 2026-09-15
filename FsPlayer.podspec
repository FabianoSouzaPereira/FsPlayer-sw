# FSPlayer.podspec
Pod::Spec.new do |spec|
  spec.name             = 'FSPlayer'
  spec.version          = '0.1.0'
  spec.summary          = 'Modern video player framework for iOs.'
  spec.description      = <<-DESC
                       FSPlayer is a modular and modern video player framework built with Swift and SwiftUI. 
                       It provides a simple API for playback control.
                       DESC
  spec.homepage         = "https://github.com/FabianoSouzaPereira/FsPlayer-sw"  
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { 'Fabiano Souza Pereira' => 'jeovajire2003@gmail.com' } 
  spec.platform         = :ios, '16.2'
  spec.source           = { :git => "https://github.com/FabianoSouzaPereira/FsPlayer-sw.git", :tag => spec.version.to_s }
  spec.swift_version    = '5.10'
  spec.frameworks       = ['Foundation', 'UIKit', 'AVFoundation', 'SwiftUI', 'Combine']
  spec.dependency 'Kingfisher', '>= 8.0', '< 8.5'
  spec.dependency 'LottieXCFramework', '4.4.3'
  spec.pod_target_xcconfig = { 'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES' }

  spec.default_subspec = File.directory?(File.join(__dir__, 'FSPlayer.xcframework')) ? 'Binary' : 'Debug'

  # ----------------------------------------
  # Binary distributon
  # ----------------------------------------

  spec.subspec 'Binary' do |binary|
    binary.vendored_frameworks = 'FSPlayer.xcframework'
    binary.resources = "Sources/FSPlayer/Resources/**/*.{plist,xib,json,ttf,xcassets,strings}"
  end
 
  # ----------------------------------------
  # Debug distributon
  # ----------------------------------------

  spec.subspec "Debug" do |debug|
    debug.source_files =  "Sources/FSPlayer/**/*.swift"
    debug.resources =  "Sources/FSPlayer/Resources/**/*.{plist,xib,json,ttf,xcassets,strings}"
  end

end
