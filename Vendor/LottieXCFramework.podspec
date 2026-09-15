Pod::Spec.new do |s|
  s.name         = 'LottieXCFramework'
  s.version      = '4.4.3'
  s.summary      = 'Prebuilt Lottie xcframework'
  s.homepage     = 'https://github.com/airbnb/lottie-ios'
  s.license      = { :type => 'Apache-2.0' }
  s.author       = { 'Airbnb' => 'https://github.com/airbnb/lottie-ios' }
  s.platform     = :ios, '13.0'
  s.source       = {
    :http => 'https://github.com/airbnb/lottie-ios/releases/download/4.4.3/Lottie-Xcode-14.1.xcframework.zip'
  }
  s.vendored_frameworks = 'Lottie.xcframework'
  s.module_name  = 'Lottie'
end
