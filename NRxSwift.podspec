Pod::Spec.new do |s|
  s.name         = "NRxSwift"
  s.version      = "0.1.2"
  s.summary      = "NRxSwift provides NKObservable - non-interrupted observable."
  s.homepage     = "http://cornerteam.com"
  s.license      = "MIT"
  s.author       = "Nghia Nguyen"
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/nghiaphunguyen/NRxSwift", :tag => s.version}
  s.source_files  = "Classes", "NRxSwift/NRxSwift/**/*.{swift}"
  s.requires_arc = true
  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }

  s.dependency 'RxSwift', '2.5.0'
end