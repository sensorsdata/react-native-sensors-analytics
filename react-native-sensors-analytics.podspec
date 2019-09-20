Pod::Spec.new do |s|
  s.name         = "RNSensorsAnalyticsModule"
  s.version      = "1.0.1"
  s.summary      = "react native sensors analytics"
  s.description  = <<-DESC
  Sensors analytics custom logging helper.
   DESC
  s.author       = { "wat" => "wat" }
  s.homepage     = "https://github.com/"
  s.license      = "Apache License 2.0"
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/sensorsdata/react-native-sensors-analytics.git", :tag => "v1.0.1" }
  s.source_files  = "ios/*.{h,m}"
  s.framework    = 'SystemConfiguration'
  s.dependency "React"
  s.dependency "SensorsAnalyticsSDK"
end

