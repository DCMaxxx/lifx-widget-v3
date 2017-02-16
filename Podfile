source 'https://github.com/CocoaPods/Specs.git'

inhibit_all_warnings!
use_frameworks!

def api_pods
       pod 'BrightFutures', '~> 5.1'
       pod 'LIFXAPIWrapper', '~> 0.0'
       pod 'SwiftyUserDefaults', '~> 3.0'
       pod 'SwiftyJSON', '~> 3.1'
end

target 'LIFX Widget' do
       platform :ios, '9.0'

       pod 'Reveal-SDK', :configurations => ['Debug']
       pod 'SwiftLint', '~> 0.16'

       api_pods

       pod 'SVProgressHUD', '~> 2.1'
       pod 'MSColorPicker', '~> 1.0'
end

target 'LIFX Widget Today Extension' do
       platform :ios, '9.0'

       pod 'Reveal-SDK', :configurations => ['Debug']

       api_pods
end

target 'LIFX Widget WatchKit App' do
       platform :watchos, '3.0'
end

target 'LIFX Widget WatchKit Extension' do
       platform :watchos, '3.0'

       api_pods
end
