# Uncomment the next line to define a global platform for your project
platform :ios, '16.0'

target 'pictoMaker' do
  
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for pictoMaker
  pod 'Google-Mobile-Ads-SDK'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|

    if target.name == 'Realm'
      create_symlink_phase = target.shell_script_build_phases.find { |x| x.name == 'Create Symlinks to Header Folders' }
      create_symlink_phase.always_out_of_date = "1"
    end
    
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
    
  end
end