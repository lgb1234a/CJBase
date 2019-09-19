Pod::Spec.new do |spec|
  spec.name          = 'CJBase'
  spec.version       = '0.11'
  spec.license       = 'Copyright (c) 2019年 Chenyn. All rights reserved.'
  spec.homepage      = 'https://git.xq5.com/cajian/CJBase_flutter_iOS.git'
  spec.authors       = { 'Chenyn le' => 'chenynle@gmail.com' }
  spec.summary       = 'Base private pod for cajian'
  spec.source        = { :git => 'https://git.xq5.com/cajian/CJBase_flutter_iOS.git', :tag => spec.version }
  spec.platform     = :ios, '8.0'
  spec.source_files       = '*.{h,m}'

  spec.framework      = 'SystemConfiguration'

  spec.dependency 'AFNetworking'
  spec.dependency 'NIMKit'
  spec.dependency 'NIMSDK_LITE'
  spec.dependency 'YYModel'
  spec.dependency 'Reachability'
  spec.dependency 'MBProgressHUD'

  spec.subspec 'Base' do |b|
    b.source_files   = 'Base/*.{h,m}'
  end

  spec.subspec 'Category' do |c|
    c.source_files   = 'Category/*.{h,m}'
  end

  spec.subspec 'Network' do |n|
    n.source_files   = 'Network/*.{h,m}'
  end
end