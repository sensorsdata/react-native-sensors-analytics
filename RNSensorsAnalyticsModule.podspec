
Pod::Spec.new do |s|
  s.name         = "RNSensorsAnalyticsModule"
  s.version      = "1.1.3"
  s.summary      = "The official React Native SDK of Sensors Analytics."
  s.description  = <<-DESC
                  神策分析 RN 组件
                   DESC
  s.homepage     = "http://www.sensorsdata.cn"
  s.license      = { :type => "Apache License, Version 2.0" }
  s.author       = { "Yuanyang Peng" => "pengyuanyang@sensorsdata.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/sensorsdata/react-native-sensors-analytics.git", :tag => "v#{s.version}" }
  s.source_files = "ios/*.{h,m}"
  s.requires_arc = true
  s.dependency   "React"
  s.dependency   "SensorsAnalyticsSDK"

end

  