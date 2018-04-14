source 'https://github.com/CocoaPods/Specs.git'

inhibit_all_warnings!
use_frameworks!

platform :ios, '9.0'

def api_pods
       pod 'BrightFutures', '~> 6.0'
       pod 'LIFXAPIWrapper', '~> 0.0'
       pod 'SwiftyUserDefaults', '~> 3.0'
       pod 'SwiftyJSON', '~> 4.0'
end

target 'LIFX Widget' do
       pod 'SwiftLint', '~> 0.25'

       api_pods

       pod 'SVProgressHUD', '~> 2.1'
       pod 'MSColorPicker', '~> 1.0'
end

target 'LIFX Widget Today Extension' do
       api_pods
end

target 'LIFX Widget Tests' do
       api_pods
end
