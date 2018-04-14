#
# Be sure to run `pod lib lint Swiftalytics.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Swiftalytics"
  s.version          = "0.5"
  s.summary          = "A declarative Swift DSL for your view tracking needs"
  s.description      = <<-DESC
                       Swiftalytics lets you use Aspect Oriented Programming to
                       declare all the analytics view tracking for your app on
                       neat one-liners in a single file!

                       * Supports both static and dynamic view tracking
                         * Assign your own closures with correct type inference
                       * Flexible tracking (not forced to viewDidAppear)
                       * Works great with [ARAnalytics](https://github.com/orta/ARAnalytics)
                       DESC
  s.homepage         = "https://github.com/MrAlek/Swiftalytics"
  s.license          = 'MIT'
  s.author           = { "Alek Åström" => "alek@iosnomad.com" }
  s.source           = { :git => "https://github.com/MrAlek/Swiftalytics.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/MisterAlek'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Source/*'
  s.frameworks = 'UIKit'

end
