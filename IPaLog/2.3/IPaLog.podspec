Pod::Spec.new do |s|
  s.name             = 'IPaLog'
  s.version          = '2.3'
  s.summary          = 'simple Log script,can work with Crashlytics by adding define IPaLogCL'
  s.homepage         = 'https://github.com/ipapamagic/IPaLog'
  s.license          = 'MIT'
  s.author           = { 'IPaPa' => 'ipapamagic@gmail.com' }
  s.source           = { :git => 'https://github.com/ipapamagic/IPaLog.git', :tag => s.version.to_s}
  s.swift_version    = '5.0'

  s.requires_arc     = true

  s.source_files = 'IPaLog.swift'

end
