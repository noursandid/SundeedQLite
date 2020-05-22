Pod::Spec.new do |s|
  s.name = 'SundeedQLite'
  s.version = '1.1.4'
  s.license = 'MIT'
  s.summary = 'Easiest offline saving in Swift using native SQLite framework'
  s.homepage = 'https://github.com/noursandid/SundeedQLite/'
  s.authors = { 'Nour Sandid' => 'noursandid@gmail.com' }
  s.source = { :git => 'https://github.com/noursandid/SundeedQLite.git', :tag => s.version }
  s.documentation_url = 'https://github.com/noursandid/SundeedQLite/'
  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'
  s.source_files = 'Library/**/*.swift'
  s.framework = 'SystemConfiguration'
end
