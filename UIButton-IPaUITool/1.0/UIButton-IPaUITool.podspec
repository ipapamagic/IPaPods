Pod::Spec.new do |s|
  s.name             = 'UIButton-IPaUITool'
  s.version          = '1.0'
  s.summary          = 'convenience function for UIButon to reposition image and title'
  s.homepage         = 'https://github.com/ipapamagic/UIButton-IPaUITool'
  s.license          = 'MIT'
  s.author           = { 'IPaPa' => 'ipapamagic@gmail.com' }
  s.source           = { :git => 'https://github.com/ipapamagic/UIButton-IPaUITool.git', :tag => s.version.to_s}

  s.platform         = :ios, "7.0"
  s.requires_arc     = true

  s.source_files = 'UIButton+IPaUITool.swift'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }
end
