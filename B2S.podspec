Pod::Spec.new do |s|  
    s.name              = 'B2S'
    s.version           = '1.0.3'
    s.summary           = 'Return your subscribers in easy way'
    s.homepage          = 'https://backtosub.com/'

    s.author            = { 'Konstantin' => 'info@backtosub.com' }
    s.license           = { :type => 'MIT', :file => 'LICENSE' }

    s.source            = { :git => "https://github.com/BackToTheSubscription/B2S.git", :tag => "#{s.version}" }
    s.source_files      = 'B2S/**/*.{h,m,swift}'
    s.resources         = 'B2S/Resources/Assets.xcassets'
    s.swift_version = '5.0'
    s.ios.deployment_target   = '12.3'
end