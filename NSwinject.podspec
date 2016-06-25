Pod::Spec.new do |s|
  s.name         = "NSwinject"
  s.version      = "0.1.1"
  s.summary      = "NSwinject is wrapper of Swinject providing class Inject<T> to auto inject properties."
  s.homepage     = "http://cornerteam.com"
  s.license      = "MIT"
  s.author       = "Nghia Nguyen"
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/nghiaphunguyen/NSwinject", :tag => s.version}
  s.source_files  = "Classes", "NSwinject/NSwinject/**/*.{swift}"
  s.requires_arc = true
  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }

  s.dependency 'Swinject', '1.1.2'
end