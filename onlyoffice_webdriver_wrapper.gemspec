# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'onlyoffice_webdriver_wrapper/version'
Gem::Specification.new do |s|
  s.name = 'onlyoffice_webdriver_wrapper'
  s.version = OnlyofficeWebdriverWrapper::Version::STRING
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.3'
  s.authors = ['Pavel Lobashov', 'Oleg Nazarov', 'Dmitry Rotaty']
  s.summary = 'ONLYOFFICE Webdriver Wrapper Gem'
  s.description = 'onlyoffice_webdriver_wrapper'
  s.email = ['shockwavenn@gmail.com', 'dafttrick@gmail.com']
  s.files = `git ls-files lib LICENSE.txt README.md`.split($RS)
  s.homepage = 'https://github.com/onlyoffice-testing-robot/onlyoffice_webdriver_wrapper'
  s.add_runtime_dependency('headless', '~> 2')
  s.add_runtime_dependency('onlyoffice_file_helper', '~> 0.1')
  s.add_runtime_dependency('onlyoffice_logger_helper', '~> 1')
  s.add_runtime_dependency('onlyoffice_s3_wrapper', '~> 0.1')
  s.add_runtime_dependency('page-object', '~> 2')
  s.add_runtime_dependency('selenium-webdriver', '3.142.3')
  s.add_runtime_dependency('watir', '~> 6')
  s.license = 'AGPL-3.0'
end
