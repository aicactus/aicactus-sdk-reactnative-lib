require 'json'
package = JSON.parse(File.read('./package.json'))

Pod::Spec.new do |s|
  s.name                = 'RNAicactus'
  s.version             = package['version']
  s.summary             = package['description']
  s.description         = <<-DESC
  AicactusSDK is a client side module for AiCactus platform.
                          DESC

  s.homepage            = 'http://aicactus.io/'
  s.social_media_url    = 'https://twitter.com/aicactus'
  s.license             = { :type => 'MIT' }
  s.author              = { 'Aicactus' => 'contact@tvpsoft.io' }
  s.source              = { :git => 'https://github.com/aicactus/aicactus-sdk-reactnative-lib.git', :tag => s.version.to_s }

  s.platform            = :ios, '11.0'
  s.source_files        = 'ios/**/*.{m,h}'
  s.static_framework    = true

  s.dependency          'AicactusSDK', '~> 1.0'
  s.dependency          'React'
end

