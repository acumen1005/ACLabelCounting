#
#  Be sure to run `pod spec lint ACLabelCounting.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ACLabelCounting"
  s.version      = "1.0.0"
  s.summary      = "Adds animated counting to UILabel for swift."
  # s.description  = <<-DESC

  s.homepage     = "https://github.com/acumen1005/ACLabelCounting"
  # s.screenshots  = "https://www.github.com/acumen1005/ACLabelCounting/ACLabelCounting.gif"
 
  s.license	 = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "acumen1005" => "407660109@qq.com" }
  s.ios.deployment_target = "8.0"

  s.source       = { :git => "https://github.com/acumen1005/ACLabelCounting.git", :tag => s.version }
  s.source_files  = "Source/*.swift"

end
