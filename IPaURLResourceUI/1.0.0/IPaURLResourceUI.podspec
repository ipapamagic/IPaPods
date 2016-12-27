Pod::Spec.new do |s|
  s.name             = 'IPaURLResourceUI'
  s.version          = '1.0.0'
  s.summary          = 'Easy API tools to auto parse result to JSON'
  s.homepage         = 'https://github.com/ipapamagic/IPaURLTool'
  s.license          = 'MIT'
  s.author           = { 'IPaPa' => 'ipapamagic@gmail.com' }
  s.source           = { :git => 'https://github.com/ipapamagic/IPaURLTool.git', :tag => '1.0.0'}

  s.platform         = :ios, "7.0"
  s.requires_arc     = true

  s.source_files = 'IPaURLResourceUI/IPaURLResourceUI/*.swift'

end
