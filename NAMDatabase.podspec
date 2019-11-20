#
# Be sure to run `pod lib lint NAMDatabase.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NAMDatabase'
  s.version          = '1.0.6'
  s.summary          = 'A Sqlite ORM'

  s.description      = <<-DESC
  Based in Doctrine PHP ORM, this ORM bring to developers productivity and more powerful database management.
                       DESC

  s.homepage         = 'https://github.com/narlei/NAMDatabase'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'narlei' => 'narlei.guitar@gmail.com' }
  s.source           = { :git => 'https://github.com/narlei/NAMDatabase.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/narleimoreira'

  s.ios.deployment_target = '9.3'

  s.source_files = 'NAMDatabase/Classes/**/*'

  s.dependency 'FMDB', '~> 2.7.5'
end
