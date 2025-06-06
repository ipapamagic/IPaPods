#
# Be sure to run `pod lib lint IPaIndicator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'IPaIndicator'
  s.version          = '4.0.1'
  s.summary          = 'A short description of IPaIndicator.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ipapamagic/IPaIndicator'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ipapamagic' => 'ipapamagic@gmail.com' }
  s.source           = { :git => 'https://github.com/ipapamagic/IPaIndicator.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  
  # s.resource_bundles = {
  #   'IPaIndicator' => ['IPaIndicator/Assets/*.png']
  # }
    
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
    
    
    
    s.subspec 'IPaIndicator' do | sp |
            sp.source_files = 'Sources/IPaIndicator/**/*'
            sp.dependency 'IPaDownloadManager', '~> 1.4.0'
            sp.dependency 'IPaURLResourceUI', '~> 6.0.0'
    end
    s.subspec 'IPaToast' do | sp |
            sp.source_files = 'Sources/IPaToast/**/*'
            sp.dependency 'IPaUIKitHelper', '~> 1.3.1'
    end
end
