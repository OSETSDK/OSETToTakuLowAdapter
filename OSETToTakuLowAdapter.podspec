Pod::Spec.new do |s|
  s.name         = "OSETToTakuLowAdapter"
  s.version      = "6.6.2.5"
  s.summary      = "AdSet广告对接Taku适配器"
  s.description  = <<-DESC
                    OSETSDK 是一个专业的广告聚合SDK，提供高效的广告展示和收益优化功能。
                    DESC
  s.homepage     = "https://github.com/OSETSDK/OSETToTakuLowAdapter"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { 'shenshi' => 'yaohaofei@shenshiads.com' }
  
  # 设置最低支持版本
  s.ios.deployment_target = '12.0'
  s.static_framework = true
  # 源文件配置
  s.source       = {
    :git => 'https://github.com/OSETSDK/OSETToTakuLowAdapter.git',
    :tag => s.version.to_s
  }
  # 主框架文件
  # 检查 OSETToBidAdapter.podspec 关键字段
  s.source_files = 'OSETToTakuLowAdapter/**/*.{h,m}'
  # 系统框架依赖
  s.frameworks = "Foundation", "UIKit", "AdSupport", "CoreTelephony", "StoreKit", "SystemConfiguration"
  
  # 资源文件
    
  # Swift版本设置
  s.swift_version = '5.0'
  
  # ================= 第三方依赖库 =================
 
  s.dependency 'OSETSDK','>=6.6.2.5'
  s.dependency 'AnyThinkiOS','<6.4.94'
end
