# Uncomment the next line to define a global platform for your project
 platform :ios, '11.0'

target 'Chick Pick Driver' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Pappea Driver
pod 'IQKeyboardManagerSwift'
pod 'Alamofire'
pod 'SDWebImage', '4.4.6'
pod 'Crashlytics'
pod 'IQDropDownTextField'
pod 'Fabric'
pod 'SwiftyJSON'
pod 'GoogleMaps', '3.0.3'
pod 'GooglePlaces', '3.0.3'
pod 'GooglePlacePicker'
pod 'SideMenuSwift'
pod 'MarqueeLabel/Swift'
pod 'Socket.IO-Client-Swift'
pod 'SRCountdownTimer'
pod 'SSSpinnerButton'
pod 'Firebase/Core'
pod 'Firebase/Messaging'
pod 'SwiftMessages'#,  '5.0.1'
pod 'SkyFloatingLabelTextField'
pod 'lottie-ios', '2.5.3'
pod 'ActionSheetPicker-3.0'
pod 'QRCodeReader.swift'
#pod 'BFKit-Swift'
#pod 'CardIO'
#pod 'TTSegmentedControl'
#pod 'MBCircularProgressBar'
#pod 'M13Checkbox'
#pod 'DropDown'
#pod 'NVActivityIndicatorView'
#pod 'FloatRatingView'
#pod 'Sheeeeeeeeet'
#pod 'ACFloatingTextfield-Swift'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
    end
  end
end
