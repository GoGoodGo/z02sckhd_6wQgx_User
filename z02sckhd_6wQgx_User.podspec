#
# Be sure to run `pod lib lint z02sckhd_6wQgx_User.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'z02sckhd_6wQgx_User'
  s.version          = '1.2.3'
  s.summary          = 'TM User.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  TM User framework
                       DESC

  s.homepage         = 'https://github.com/GoGoodGo/z02sckhd_6wQgx_User'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'OYangHui' => '442371047@qq.com' }
  s.source           = { :git => 'https://github.com/GoGoodGo/z02sckhd_6wQgx_User.git', :tag => s.version.to_s }
  
  s.static_framework = true
  s.requires_arc = true
  s.swift_version = '4.2'
  s.ios.deployment_target = '9.0'
  
  s.xcconfig = {
      'VALID_ARCHS' => 'arm64 x86_64',
  }
  
  #s.vendored_libraries = 'z02sckhd_6wQgx_User/Classes/ThirdParty/*.a'
  
  s.vendored_frameworks = 'z02sckhd_6wQgx_User/Classes/ThirdParty/*.framework'
  
  s.resource = 'z02sckhd_6wQgx_User/Classes/ThirdParty/*.bundle'
  
  s.source_files = 'z02sckhd_6wQgx_User/Classes/**/**/**/*.swift',  'z02sckhd_6wQgx_User/Classes/ThirdParty/AlipaySDK.framework/Headers/*.h'
  
  s.resource_bundles = {
      'z02sckhd_6wQgx_User' => ['z02sckhd_6wQgx_User/Classes/**/**/**/*.xib', 'z02sckhd_6wQgx_User/Classes/Mine/*.plist', 'z02sckhd_6wQgx_User/Assets/Crop/**/*.png']
  }
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.libraries = 'sqlite3.0', 'z', 'c++'
  s.frameworks = 'Security', 'CoreMotion', 'CFNetwork', 'SystemConfiguration', 'CoreTelephony', 'QuartzCore', 'CoreText', 'CoreGraphics'
  
  s.dependency 'Kingfisher'
  s.dependency 'Cosmos'
  s.dependency 'YHTool', '~> 1.1.6'
  
  s.dependency 'MJRefresh', '~> 3.1.12'
  s.dependency 'IQKeyboardManager'
  #s.dependency 'WechatOpenSDK'
  
  #s.dependency 'TMSDK', '~> 0.0.2-beta.3'
  #s.dependency 'TMShare', '~> 0.0.2-beta.1'
  
  #s.dependency 'TMSDK', :git => 'https://gitee.com/tmgc/TMSDKSpec.git'
  #s.dependency 'TMShare', :git => 'https://gitee.com/tmgc/TMShareSpec.git'
  
  #s.dependency 'TMSDK', '~> 0.0.2-beta.7'
  #s.dependency 'TMShare', '~> 0.0.2-beta.3'
  s.dependency 'TMNavigation', '~> 0.0.2-beta.3'
  s.dependency 'TMUserCenter', '~> 0.0.2'
  
  #s.dependency 'AFNetworking', '~> 2.3'
  #s.dependency 'SVProgressHUD', '~> 2.0.3'
  #s.dependency 'UMengAnalytics-NO-IDFA', '~> 4.2.5'
  #s.dependency 'YYModel', '~> 1.0.4'
  #s.dependency 'Masonry', '~> 1.1.0'
  
  
  
  
  
  
  
  
end
