Pod::Spec.new do |spec|
  spec.name          = 'CJBase'
  spec.version       = '0.17'
  spec.license       = 'Copyright (c) 2019年 Chenyn. All rights reserved.'
  spec.homepage      = 'https://git.xq5.com/cajian/CJBase.git'
  spec.authors       = { 'Chenyn le' => 'chenynle@gmail.com' }
  spec.summary       = 'Base private pod for cajian'
  spec.source        = { :git => 'https://git.xq5.com/cajian/CJBase.git', :tag => spec.version }
  spec.platform     = :ios, '8.0'

  spec.source_files       = '**/*.{h,m}', '*.{h,m}'
  spec.public_header_files = '**/*.{h}', '*.h'
  spec.resources = '**/*.{xib}'

  spec.framework      = 'SystemConfiguration'

  spec.dependency 'AFNetworking'
  spec.dependency 'NIMKit'
  spec.dependency 'NIMSDK_LITE'
  spec.dependency 'YYModel'
  spec.dependency 'Reachability'
  spec.dependency 'MBProgressHUD'

  # spec.subspec 'Base' do |b|
  #   b.source_files   = 'Base/*.{h,m}'

  #   b.public_header_files = 'Base/*.h'
  # end

  # spec.subspec 'Category' do |c|
  #   c.dependency 'MBProgressHUD'

  #   c.source_files   = 'Category/*.{h,m}'
  #   c.public_header_files = 'Category/*.h'
  # end

  # spec.subspec 'Network' do |n|
  #   n.dependency 'CJBase/Category'
  #   n.dependency 'CJBase/Base'

  #   n.source_files   = 'Network/*.{h,m}', 'HttpConstant.h'
  #   n.public_header_files = 'Network/*.h'
  # end
end
