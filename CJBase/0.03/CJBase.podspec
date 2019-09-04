Pod::Spec.new do |spec|
  spec.name          = 'CJBase'
  spec.version       = '0.03'
  spec.license       = 'Copyright (c) 2019年 Chenyn. All rights reserved.'
  spec.homepage      = 'https://git.xq5.com/cajian/CJBase_flutter_iOS.git'
  spec.authors       = { 'Chenyn le' => 'chenynle@gmail.com' }
  spec.summary       = 'Base private pod for cajian'
  spec.source        = { :git => 'https://git.xq5.com/cajian/CJBase_flutter_iOS.git', :tag => spec.version }
  spec.platform     = :ios, '8.0'
  spec.source_files       = '*.{h,m}'

  spec.framework      = 'SystemConfiguration'

  # spec.dependency 'AFNetworking'
  # spec.dependency 'NIMKit'
  # spec.dependency 'YYModel'
  # spec.dependency 'Reachability'
end