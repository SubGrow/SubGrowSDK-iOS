use_frameworks!

target 'B2SExampleApp' do
  platform :ios, '13.0'
  pod 'SwiftyStoreKit'
end
post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end
