#
# Be sure to run `pod lib lint NAMDatabase.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NAMDatabase'
  s.version          = '1.0.3'
  s.summary          = 'A Sqlite ORM'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Based in Doctrine PHP ORM, this ORM bring to developers productivity and more powerful database management.
                       DESC

  s.homepage         = 'https://github.com/narlei/NAMDatabase'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'narlei' => 'narlei.guitar@gmail.com' }
  s.source           = { :git => 'https://github.com/narlei/NAMDatabase.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.3'

  s.source_files = 'NAMDatabase/Classes/**/*'

  s.dependency 'FMDB', '~> 2.7.5'
end
