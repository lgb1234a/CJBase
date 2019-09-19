Pod::Spec.new do |spec|
  spec.name          = 'CJBase'
  spec.version       = '0.11'
  spec.license       = 'Copyright (c) 2019年 Chenyn. All rights reserved.'
  spec.homepage      = 'https://git.xq5.com/cajian/CJBase_flutter_iOS.git'
  spec.authors       = { 'Chenyn le' => 'chenynle@gmail.com' }
  spec.summary       = 'Base private pod for cajian'
  spec.source        = { :git => 'https://git.xq5.com/cajian/CJBase_flutter_iOS.git', :tag => spec.version }
  spec.platform     = :ios, '8.0'
  spec.source_files       = 'CJBase.h'
  spec.public_header_files = 'CJBase.h'

  spec.framework      = 'SystemConfiguration'

  spec.subspec 'Base' do |b|
    b.source_files   = 'CJBase/XTSafeCollection.{h,m}'
  end

  spec.subspec 'Category' do |c|
    c.dependency 'MBProgressHUD'

    c.source_files   = 'CJBase/*{+}*.{h,m}'
  end

  spec.subspec 'Network' do |n|
    n.dependency 'CJBase/Category'
    n.dependency 'CJBase/Base'

    n.dependency 'AFNetworking'
    n.dependency 'NIMKit'
    n.dependency 'NIMSDK_LITE'
    n.dependency 'YYModel'
    n.dependency 'Reachability'

    n.source_files   = 'CJBase/{HttpHelper, HttpConstant, BaseModel}.{h,m}'
  end
end