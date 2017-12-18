# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

def open_sources
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!

  # Pods for BoostMINI
    pod 'SwiftLint'
    # pod 'Alamofire', '~> 4.5'
    # pod 'RealReachability'
    # pod 'Realm'
    # pod 'Toast-Swift', '~> 3.0.1'
    # pod 'ImageViewer', '>= 5.0'	#dkpark add
    # pod 'SwiftyBeaver', '~> 1.4.3'

# for Analytics

# for Debugging
    # pod 'Fabric'
    # pod 'Crashlytics'
    # pod 'FLEX', 	:configurations => ['Debug', 'DebugOnLive', 'Release', 'Stage']  #hslee add, https://github.com/Flipboard/FLEX
    # pod 'Buglife',  :configurations => ['Debug', 'DebugOnLive', 'Release', 'Stage']  #hslee add, https://www.buglife.com

end


target 'BoostMINI' do
	open_sources
end

# target 'LysnVideoOnly' do
# 	pod_list
# end

#target 'LysnTests' do
#	pod_list
#	inherit! :search_paths
#	# Pods for testing
#	pod 'Realm/Headers'
#end
#
#target 'LysnUITests' do
#	pod_list
#	inherit! :search_paths
#	# Pods for testing
#end


post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['SWIFT_VERSION'] = '4.0'
		end
	end
end
