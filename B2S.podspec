Pod::Spec.new do |s|  
    s.name              = 'B2S'
    s.version           = '1.0.2'
    s.summary           = 'Return your subscribers in easy way'
    s.homepage          = 'https://backtosub.com/'

    s.author            = { 'Konstantin' => 'info@backtosub.com' }
    s.license           = { :type => 'MIT', :file => 'LICENSE' }

    s.platform          = :ios
    s.source            = { :git => "https://github.com/BackToTheSubscription/B2S", :tag => "#{spec.version}" }
    s.source_files      = "B2S/**/*"
    s.ios.deployment_target   = '12.3'
end